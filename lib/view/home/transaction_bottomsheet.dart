import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tracker/controller/home_controller.dart';
import 'package:tracker/helper/app_message.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/date_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/model/transaction_model.dart';
import 'package:tracker/view/widget/formatter/amount_formatter.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import 'package:tracker/view/widget/common_widget.dart';

class TransactionBottomsheet extends StatefulWidget {
  const TransactionBottomsheet({super.key});

  @override
  State<TransactionBottomsheet> createState() => _TransactionBottomSheetState();

  static Future<void> show() {
    return showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TransactionBottomsheet(),
    );
  }
}

class _TransactionBottomSheetState extends State<TransactionBottomsheet> {
  final HomeController homeController = Get.find<HomeController>();

  String type = 'Expense';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = 'Miscellaneous'; // 👈 Default selection
  }

  @override
  Widget build(BuildContext context) {
    final colorHelper = AppColorHelper();
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: colorHelper.cardColor.withOpacity(0.95),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // top handle
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 22),
                          decoration: BoxDecoration(
                            color:
                                colorHelper.primaryTextColor.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Header
                      Center(
                        child: appText(
                          "Add ${type == 'Expense' ? 'Expense' : 'Income'}",
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colorHelper.primaryTextColor,
                        ),
                      ),
                      height(18),

                      // Expense / Income switch
                      Center(
                        child: Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: colorHelper.backgroundColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: _buildTypeChip(
                                    'Expense', colorHelper.borrowColor),
                              ),
                              width(8),
                              Expanded(
                                  child: _buildTypeChip(
                                      'Income', colorHelper.lendColor)),
                            ],
                          ),
                        ),
                      ),
                      height(25),

                      // Amount input
                      TextField(
                        inputFormatters: [
                          AmountFormatter(
                              maxDigitsBeforeDecimal: 8,
                              maxDigitsAfterDecimal: 2),
                        ],
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: _inputDecoration(
                          "Amount",
                          prefixIcon: Icons.currency_rupee_rounded,
                          colorHelper: colorHelper,
                        ),
                      ),
                      height(20),

                      // Category
                      appText("Category",
                          fontWeight: FontWeight.w600,
                          color: colorHelper.primaryTextColor),
                      height(10),
                      _categorySelector(),

                      height(25),
                      appText("Select Date",
                          fontWeight: FontWeight.w600,
                          color: colorHelper.primaryTextColor),
                      height(8),
                      _calendar(firstDayOfMonth, lastDayOfMonth),

                      height(25),

                      // Description
                      TextField(
                        controller: descriptionController,
                        decoration: _inputDecoration(
                          "Description (Optional)",
                          prefixIcon: Icons.note_outlined,
                          colorHelper: colorHelper,
                        ),
                        maxLines: 2,
                      ),
                      height(30),

                      // Save button
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 150,
                          child: buttonContainer(
                            appText(
                              type == 'Expense'
                                  ? "Save Expense"
                                  : "Save Income",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            color: type == 'Expense'
                                ? AppColorHelper().expenseColor
                                : AppColorHelper().lendColor,
                            onPressed: _onSavePressed,
                          ),
                        ),
                      ),
                      height(8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ----------------- UI HELPERS -----------------
  Widget _buildTypeChip(String label, Color color) {
    final isSelected = type == label;
    return GestureDetector(
      onTap: () => setState(() => type = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: appText(label,
              color: AppColorHelper().primaryTextColor,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _categorySelector() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categoryIcons.length,
        separatorBuilder: (_, __) => width(10),
        itemBuilder: (context, index) {
          final cat = categoryIcons[index];
          final isSelected = selectedCategory == cat['name'];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory =
                    isSelected ? null : cat['name']; // toggle selection
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: isSelected ? 165 : 75,
              decoration: BoxDecoration(
                color:
                    isSelected ? cat['color'] : cat['color'].withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: cat['color'].withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'],
                      color: Colors.black, size: isSelected ? 28 : 24),
                  height(5),
                  appText(
                    cat['name'],
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColorHelper().primaryTextColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _calendar(DateTime firstDay, DateTime lastDay) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorHelper().backgroundColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TableCalendar(
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: selectedDate,
        selectedDayPredicate: (day) => DateHelper.isSameDate(day, selectedDate),
        onDaySelected: (selected, _) => setState(() => selectedDate = selected),
        availableGestures: AvailableGestures.none,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle:
              textStyle(15, AppColorHelper().primaryTextColor, FontWeight.w600),
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColorHelper().primaryTextColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: type == 'Expense'
                ? AppColorHelper().borrowColor
                : AppColorHelper().lendColor,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          weekendTextStyle: TextStyle(color: AppColorHelper().primaryTextColor),
          defaultTextStyle: TextStyle(color: AppColorHelper().primaryTextColor),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label, {
    IconData? prefixIcon,
    String? hintText,
    required AppColorHelper colorHelper,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Neutral adaptive background (not dependent on expense/income color)
    final neutralBg = isDark
        ? colorHelper.primaryColorDark.withOpacity(0.1)
        : colorHelper.primaryColorLight.withOpacity(0.07);

    final focusColor =
        type == 'Expense' ? colorHelper.borrowColor : colorHelper.lendColor;

    return InputDecoration(
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon,
              color: colorHelper.primaryTextColor.withOpacity(0.7))
          : null,
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: neutralBg,
      labelStyle: textStyle(
        14,
        colorHelper.primaryTextColor.withOpacity(0.75),
        FontWeight.w500,
      ),
      hintStyle: textStyle(
        14,
        colorHelper.primaryTextColor.withOpacity(0.55),
        FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusColor, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  /// ----------------- LOGIC -----------------
  void _onSavePressed() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      showErrorSnackbar(message: "Please enter a valid amount");
      return;
    }

    final tx = TransactionModel(
      amount: amount,
      category: selectedCategory ?? 'Uncategorized',
      date: selectedDate,
      description: descriptionController.text.trim(),
      type: type,
    );

    homeController.addTransaction(tx);
    Get.back();
  }

  final List<Map<String, dynamic>> categoryIcons = [
    {
      'name': 'Food',
      'icon': Icons.fastfood_outlined,
      'color': AppColorHelper().foodColor
    },
    {
      'name': 'Fuel',
      'icon': Icons.local_gas_station_outlined,
      'color': AppColorHelper().fuelColor
    },
    {
      'name': 'Travel',
      'icon': Icons.flight_takeoff_outlined,
      'color': AppColorHelper().travelColor
    },
    {
      'name': 'Home Rent',
      'icon': Icons.home_outlined,
      'color': AppColorHelper().homeRentColor
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag_outlined,
      'color': AppColorHelper().shoppingColor
    },
    {
      'name': 'Movies',
      'icon': Icons.movie_outlined,
      'color': AppColorHelper().moviesColor
    },
    {
      'name': 'Bills',
      'icon': Icons.receipt_long_outlined,
      'color': AppColorHelper().billsColor
    },
    {
      'name': 'Recharge',
      'icon': Icons.phone_android_outlined,
      'color': AppColorHelper().rechargeColor
    },
    {
      'name': 'Salary',
      'icon': Icons.attach_money_rounded,
      'color': AppColorHelper().salaryColor
    },
    {
      'name': 'Savings',
      'icon': Icons.account_balance_wallet_outlined,
      'color': AppColorHelper().savingsColor
    },
    {
      'name': 'Miscellaneous',
      'icon': Icons.star,
      'color': AppColorHelper().missColor
    },
  ];
}
