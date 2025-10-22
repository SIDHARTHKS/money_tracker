import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tracker/helper/app_message.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/model/transaction_model.dart';
import '../helper/core/base/app_base_controller.dart';

class TransactionsController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //transactions
  late Box<TransactionModel> _txBox;
  var transactions = <TransactionModel>[].obs;
  final RxMap<String, List<List<TransactionModel>>>
      sortedTransactionsByMonthMap =
      <String, List<List<TransactionModel>>>{}.obs;
  RxList<TransactionModel> rxGraphMonthdata = <TransactionModel>[].obs;
  final rxGraphData = <String, double>{}.obs;

  //
  RxInt expandedIndex = (-1).obs;
  var expandedIndexMap = <int, int>{}.obs;

  // chart
  final Map<String, double> expenseData = {
    'Food': 2500,
    'Travel': 1200,
    'Fuel': 800,
    'Shopping': 500,
  };

  ///
  final List<Map<String, dynamic>> categoryIcons = [
    {
      'name': 'Food',
      'icon': Icons.fastfood_outlined,
      'color': AppColorHelper().foodColor,
    },
    {
      'name': 'Salary',
      'icon': Icons.attach_money_rounded,
      'color': AppColorHelper().salaryColor,
    },
    {
      'name': 'Fuel',
      'icon': Icons.local_gas_station_outlined,
      'color': AppColorHelper().fuelColor,
    },
    {
      'name': 'Travel',
      'icon': Icons.flight_takeoff_outlined,
      'color': AppColorHelper().travelColor,
    },
    {
      'name': 'Home Rent',
      'icon': Icons.home_outlined,
      'color': AppColorHelper().homeRentColor,
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag_outlined,
      'color': AppColorHelper().shoppingColor,
    },
    {
      'name': 'Movies',
      'icon': Icons.movie_outlined,
      'color': AppColorHelper().moviesColor,
    },
    {
      'name': 'Bills',
      'icon': Icons.receipt_long_outlined,
      'color': AppColorHelper().billsColor,
    },
    {
      'name': 'Recharge',
      'icon': Icons.phone_android_outlined,
      'color': AppColorHelper().rechargeColor,
    },
    {
      'name': 'Savings',
      'icon': Icons.account_balance_wallet_outlined,
      'color': AppColorHelper().savingsColor,
    },
  ];

  final List<Map<String, String>> categoryTypes = [
    {'type': 'Food'},
    {'type': 'Salary'},
    {'type': 'Fuel'},
    {'type': 'Travel'},
    {'type': 'Home Rent'},
    {'type': 'Shopping'},
    {'type': 'Movies'},
    {'type': 'Bills'},
    {'type': 'Recharge'},
    {'type': 'Savings'},
  ];

  //////////////////////////////////////////////////////////////////transactions

  Future<void> loadAll() async {
    final allTx = _txBox.values.toList();
    allTx.sort((a, b) => b.date.compareTo(a.date));

    // Group by month first
    final Map<String, Map<String, List<TransactionModel>>> monthGrouped = {};

    for (var tx in allTx) {
      final monthKey = DateFormat('MM/yyyy').format(tx.date); // e.g., "10/2025"
      final dayKey =
          DateFormat('dd/MM/yyyy').format(tx.date); // e.g., "21/10/2025"

      if (!monthGrouped.containsKey(monthKey)) monthGrouped[monthKey] = {};
      if (!monthGrouped[monthKey]!.containsKey(dayKey)) {
        monthGrouped[monthKey]![dayKey] = [];
      }

      monthGrouped[monthKey]![dayKey]!.add(tx);
    }

    // Sort months descending
    final sortedMonthKeys = monthGrouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MM/yyyy').parse(a);
        final dateB = DateFormat('MM/yyyy').parse(b);
        return dateB.compareTo(dateA); // newest month first
      });

    // Build the final structure
    sortedTransactionsByMonthMap.clear();
    for (var monthKey in sortedMonthKeys) {
      final daysMap = monthGrouped[monthKey]!;

      // Sort days descending
      final sortedDays = daysMap.keys.toList()
        ..sort((a, b) => DateFormat('dd/MM/yyyy')
            .parse(b)
            .compareTo(DateFormat('dd/MM/yyyy').parse(a)));

      // Push daily lists in order
      sortedTransactionsByMonthMap[monthKey] =
          sortedDays.map((day) => daysMap[day]!).toList();
    }

    // Update the flat list too
    transactions.value = allTx;
  }

  // Add transaction (returns key)
  Future<int> addTransaction(TransactionModel tx) async {
    final key = await _txBox.add(tx);
    await loadAll();
    // calculateAll();
    return key;
  }

  // Delete transaction (using key)
  Future<void> deleteTransaction(int key) async {
    await _txBox.delete(key);
    await loadAll();
    // calculateAll();
  }

  // Update: either modify fields and call save() on the HiveObject or putAt / put(key, value)
  Future<void> updateTransaction(int key, TransactionModel updated) async {
    await _txBox.put(key, updated);
    await loadAll();
  }

  // Query by month
  List<TransactionModel> getTransactionsByMonth(DateTime month) {
    return _txBox.values
        .where(
            (tx) => tx.date.year == month.year && tx.date.month == month.month)
        .toList();
  }

  double getTotalIncome(DateTime month) {
    return getTransactionsByMonth(month)
        .where((t) => t.type == 'Income')
        .fold(0.0, (s, t) => s + t.amount);
  }

  double getTotalExpense(DateTime month) {
    return getTransactionsByMonth(month)
        .where((t) => t.type == 'Expense')
        .fold(0.0, (s, t) => s + t.amount);
  }

  double getNetChange(DateTime month) {
    return getTotalIncome(month) - getTotalExpense(month);
  }

  List<TransactionModel> getTransactionsBySelectedMonth(DateTime date) {
    final selectedMonth = DateFormat('MM/yyyy').format(date);
    final monthData = sortedTransactionsByMonthMap[selectedMonth];
    if (monthData == null) return [];
    return monthData.expand((dayList) => dayList).toList();
  }

  Map<String, double> sortGraphByType(DateTime date) {
    final Map<String, double> data = {};
    for (var tx in rxGraphMonthdata) {
      if (tx.type.toLowerCase() == 'expense') {
        // only count spends
        data[tx.category] = (data[tx.category] ?? 0) + tx.amount;
      }
    }
    return data;
  }

  void getPieChartData(DateTime date) {
    rxGraphMonthdata.value = getTransactionsBySelectedMonth(date);
    rxGraphData.value = sortGraphByType(date);
    appLog('Pie chart data: ${rxGraphData.value}');
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    // Open boxes first
    _txBox = Hive.box<TransactionModel>('transactions');

    // Load initial data
    await loadAll();

    // Watch for changes
    _txBox.watch().listen((event) => loadAll());

    getPieChartData(DateTime.now());
  }
}
