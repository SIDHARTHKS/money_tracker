import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tracker/helper/date_helper.dart' show DateHelper;
import 'package:tracker/model/transaction_model.dart';
import '../gen/assets.gen.dart';
import '../helper/color_helper.dart';
import '../helper/core/base/app_base_controller.dart';
import '../model/ledger_model.dart';
import '../model/salary_model.dart';

class HomeController extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  //
  final isInitCalled = false.obs;
  final RxInt selectedBottomMenuIndex = 0.obs;
  RxString rxUserName = ''.obs;
  RxString rxUserImg = ''.obs;
  RxString rxUserId = "".obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  // funds
  RxDouble rxTotalbalance = 0.0.obs;
  RxDouble rxTotalspend = 0.0.obs;
  RxDouble rxTotalincome = 0.0.obs;

  int? currentSalaryKey;

  // ledger
  var rxledger = <LedgerModel>[].obs;
  var rxLends = <LedgerModel>[].obs;
  var rxBorrows = <LedgerModel>[].obs;
  var rxledgerDifference = 0.0;

  RxDouble rxLendSum = 0.0.obs;
  RxDouble rxBorrowSum = 0.0.obs;

  final sortedLedgersByDate = <List<LedgerModel>>[].obs;

  // transactions list
  late Box<TransactionModel> _txBox;
  var transactions = <TransactionModel>[].obs;
  final RxList<List<TransactionModel>> sortedTransactionsByDate =
      <List<TransactionModel>>[].obs;

  late Box<LedgerModel> _ledgerbox;

  late Box<SalaryModel> _salbox;
  late Box<SalaryModel> salaryBox;
  RxDouble salary = 0.0.obs;

  //
  RxInt expandedIndex = (-1).obs;
  var expandedIndexMap = <int, int>{}.obs;
  //

  Future<void> updateMonth(DateTime date) async {
    selectedDate.value = date;
    // await loadMonthData(date);
  }

  List<Map<String, dynamic>> navBarItems = [
    {"title": "Home", "icon": Assets.icons.home.path},
    {"title": "Ledger", "icon": Assets.icons.giveMoney.path},
  ];

  void changeIndex(int index) {
    selectedBottomMenuIndex.value = index;
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  //////////////////////////////////////////////////////////////////transactions

  Future<void> loadAll() async {
    // Load all transactions from Hive
    final allTx = _txBox.values.toList();
    // Sort all transactions by date (newest first)
    allTx.sort((a, b) => b.date.compareTo(a.date));

// Group transactions by date
//grouped = {
//   "17/10/2025": [ Salary ],
//   "16/10/2025": [ Food, Movies ],
//   "15/10/2025": [ Fuel, Travel ],
// };

    final Map<String, List<TransactionModel>> grouped = {};

    for (var tx in allTx) {
      final dateKey = DateHelper.convertDateTimeToString(dateTime: tx.date);
      // e.g. "16/10/2025"

      if (grouped.containsKey(dateKey)) {
        grouped[dateKey]!.add(tx);
      } else {
        grouped[dateKey] = [tx];
      }
    }

    // --- Sorting keys with 'today' always at the top ---
    final todayKey = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('dd/MM/yyyy').parse(a);
        final dateB = DateFormat('dd/MM/yyyy').parse(b);

        // ✅ Keep today's group at top
        if (a == todayKey) return -1;
        if (b == todayKey) return 1;

        // Otherwise sort by date (descending)
        return dateB.compareTo(dateA);
      });

    // Build the sorted transaction list
    sortedTransactionsByDate.value =
        sortedKeys.map((key) => grouped[key]!).toList();

    // Update the flat list too
    transactions.value = allTx;
  }

  // Add transaction (returns key)
  Future<int> addTransaction(TransactionModel tx) async {
    final key = await _txBox.add(tx);
    await loadAll();
    calculateAll();
    return key;
  }

  // Delete transaction (using key)
  Future<void> deleteTransaction(int key) async {
    await _txBox.delete(key);
    await loadAll();
    calculateAll();
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

  ///////////////////////////////////////////////////////////salary
  ///
  ///
  void load() {
    if (_salbox.isNotEmpty) {
      double total = 0.0;

      for (var entry in _salbox.values) {
        total += entry.totalSalary;
      }
      salary.value = total;
    } else {
      salary.value = 0.0;
    }
    salaryBox = _salbox;
    // calculateAll();
  }

  Future<void> setSalary(double total) async {
    if (currentSalaryKey != null) {
      await deleteSalary(currentSalaryKey!); // delete existing
    }
    final model = SalaryModel(totalSalary: total, updatedAt: DateTime.now());
    final key = await _salbox.add(model);
    currentSalaryKey = key;
    load();
    calculateAll();
  }

  Future<void> deleteSalary(int key) async {
    await _salbox.delete(key);
    currentSalaryKey = null;
    load();
  }

  ///////////////////////////////////////////////////////////ledger
  ///
  ///
  Future<void> loadAllLedger() async {
    // Load all ledger items
    final allItems = _ledgerbox.values.toList();

    // Sort all items by date (newest first)
    allItems.sort((a, b) => b.date.compareTo(a.date));

    // Store in reactive list
    rxledger.value = allItems;

    // Filter and store lends & borrows
    rxLends.value = allItems.where((ledger) => ledger.type == 'lend').toList();
    rxBorrows.value =
        allItems.where((ledger) => ledger.type == 'borrow').toList();

    // --- Group ledgers by date ---
    final Map<String, List<LedgerModel>> grouped = {};
    for (var ledger in allItems) {
      final dateKey = DateHelper.convertDateTimeToString(dateTime: ledger.date);
      if (grouped.containsKey(dateKey)) {
        grouped[dateKey]!.add(ledger);
      } else {
        grouped[dateKey] = [ledger];
      }
    }

    // --- Sort keys with today's date always first ---
    final todayKey = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('dd/MM/yyyy').parse(a);
        final dateB = DateFormat('dd/MM/yyyy').parse(b);

        if (a == todayKey) return -1; // today's group first
        if (b == todayKey) return 1;
        return dateB.compareTo(dateA); // then descending
      });

    // --- Build a sorted grouped list for UI use ---
    sortedLedgersByDate.value = sortedKeys.map((key) => grouped[key]!).toList();

    // --- Update totals ---
    calculateLend();
    calculateBorrow();
  }

  Future<int> addLedger(LedgerModel item) async {
    final key = await _ledgerbox.add(item);
    await loadAllLedger();
    return key;
  }

  void calculateLend() {
    rxLendSum.value = rxLends.fold(0.0, (sum, ledger) => sum + ledger.amount);
  }

  void calculateBorrow() {
    rxBorrowSum.value =
        rxBorrows.fold(0.0, (sum, ledger) => sum + ledger.amount);
  }

  Future<void> deleteLedger(int key) async {
    await _ledgerbox.delete(key);
    await loadAllLedger();
  }

  ///////////////////////////////////////////////////////////
  ///

  Future<void> calculateAll() async {
    double income = 0.0;
    double spend = 0.0;

    for (var tx in transactions) {
      if (tx.type == "Income") {
        income += tx.amount;
      } else if (tx.type == "Expense") {
        spend += tx.amount;
      }
    }
    rxTotalbalance.value = salary.value - spend;
    rxTotalspend.value = spend;
    salary.value = salary.value;
    rxTotalincome.value = income;
  }

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

  bool isPositive() {
    final lend = rxLends.fold(0.0, (sum, ledger) => sum + ledger.amount);
    final borrow = rxBorrows.fold(0.0, (sum, ledger) => sum + ledger.amount);

    rxledgerDifference = lend - borrow;
    return rxledgerDifference >= 0;
  }

  // Future<void> loadMonthData(DateTime month) async {
  //   // Normalize month to YYYY-MM (ignore day)
  //   final normalizedMonth = DateTime(month.year, month.month);

  //   // ✅ Filter transactions for the selected month
  //   final monthTxs = _txBox.values
  //       .where((tx) =>
  //           tx.date.year == normalizedMonth.year &&
  //           tx.date.month == normalizedMonth.month)
  //       .toList()
  //     ..sort((a, b) => b.date.compareTo(a.date));

  //   currentMonthTransactions.assignAll(monthTxs);

  //   // ✅ Find salary for this month (if any)
  //   final sal = _salbox.values.firstWhere(
  //     (s) =>
  //         s.month.year == normalizedMonth.year &&
  //         s.month.month == normalizedMonth.month,
  //     orElse: () => SalaryModel(totalSalary: 0.0, month: normalizedMonth),
  //   );

  //   currentMonthSalary.value = sal;

  //   // ✅ Calculate monthly totals
  //   calculateMonthlyTotals();
  // }

  // void calculateMonthlyTotals() {
  //   double income = 0.0;
  //   double expense = 0.0;

  //   for (var tx in currentMonthTransactions) {
  //     if (tx.type == "Income") {
  //       income += tx.amount;
  //     } else if (tx.type == "Expense") {
  //       expense += tx.amount;
  //     }
  //   }

  //   final goal = currentMonthSalary.value?.totalSalary ?? 0.0;

  //   rxTotalincome.value = income;
  //   rxTotalspend.value = expense;
  //   rxTotalbalance.value = goal - expense;
  // }

  @override
  Future<void> onInit() async {
    super.onInit();

    // Open boxes first
    _txBox = Hive.box<TransactionModel>('transactions');
    _salbox = Hive.box<SalaryModel>('salaryBox');
    _ledgerbox = Hive.box<LedgerModel>('ledger');

    // Load initial data
    await loadAll();
    load();
    await loadAllLedger();

    // Watch for changes
    _txBox.watch().listen((event) => loadAll());
    _salbox.watch().listen((_) => load());
    _ledgerbox.watch().listen((_) => loadAllLedger());

    // Set current month
    await updateMonth(DateTime.now());

    calculateAll();
  }
}
