import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tracker/controller/home_controller.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/date_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/model/transaction_model.dart';
import 'package:tracker/view/widget/common_widget.dart';
import 'package:tracker/view/widget/text/app_text.dart';

class TransactionBottomsheet extends StatefulWidget {
  const TransactionBottomsheet({super.key});

  @override
  State<TransactionBottomsheet> createState() => _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends State<TransactionBottomsheet> {
  final HomeController homeController = Get.find<HomeController>();

  String type = 'Expense';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return Container(
      decoration: BoxDecoration(
        color: AppColorHelper().cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, -2),
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColorHelper().borderColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              /// 💡 Expense / Income Selector
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColorHelper().backgroundColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTypeChip('Expense', AppColorHelper().borrowColor),
                      width(8),
                      _buildTypeChip('Income', AppColorHelper().lendColor),
                    ],
                  ),
                ),
              ),
              height(20),

              /// 💰 Amount
              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration(
                  "Amount",
                  prefixIcon: Icons.currency_rupee_rounded,
                ),
              ),
              height(16),

              /// 🏷️ Category Chips
              appText("Category",
                  fontWeight: FontWeight.w600,
                  color: AppColorHelper().primaryTextColor),
              height(10),
              selectedCategory == null ? Container() : height(0),
              SizedBox(
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
                          if (selectedCategory == cat['name']) {
                            selectedCategory =
                                null; // deselect if already selected
                          } else {
                            selectedCategory = cat['name']; // select new one
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? 177 : 75,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cat['color']
                              : cat['color'].withOpacity(0.45),
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
                                color: Colors.black,
                                size: isSelected ? 28 : 24),
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
              ),
              height(20),

              appText("Select Date",
                  fontWeight: FontWeight.w600,
                  color: AppColorHelper().primaryTextColor),
              height(8),

              Container(
                decoration: BoxDecoration(
                  color: AppColorHelper().backgroundColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TableCalendar(
                  firstDay: firstDayOfMonth,
                  lastDay: lastDayOfMonth,
                  focusedDay: selectedDate,
                  selectedDayPredicate: (day) =>
                      DateHelper.isSameDate(day, selectedDate),
                  onDaySelected: (selected, _) {
                    setState(() => selectedDate = selected);
                  },
                  availableGestures:
                      AvailableGestures.none, // disable month swipes
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: textStyle(
                        15, AppColorHelper().primaryTextColor, FontWeight.w600),
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
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 14),
                    weekendTextStyle:
                        TextStyle(color: AppColorHelper().primaryTextColor),
                    defaultTextStyle:
                        TextStyle(color: AppColorHelper().primaryTextColor),
                  ),
                ),
              ),
              height(20),

              /// 📝 Description
              TextField(
                controller: descriptionController,
                decoration: _inputDecoration(
                  "Description (Optional)",
                  prefixIcon: Icons.note_outlined,
                ),
                maxLines: 2,
              ),
              height(25),

              /// ✅ Save Button
              SizedBox(
                height: 50,
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    if (type == 'Expense') {
                      _saveExpense();
                    } else {
                      _saveIncome();
                    }
                  },
                  icon: const Icon(Icons.check_rounded),
                  label:
                      Text(type == 'Expense' ? "Save Expense" : "Save Income"),
                  style: FilledButton.styleFrom(
                    backgroundColor: type == 'Expense'
                        ? AppColorHelper().borrowColor
                        : AppColorHelper().lendColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Type selector chip
  Widget _buildTypeChip(String label, Color color) {
    final isSelected = type == label;
    return GestureDetector(
      onTap: () => setState(() => type = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: appText(label,
            color: isSelected
                ? AppColorHelper().primaryTextColor
                : AppColorHelper().primaryTextColor,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  // Save expense/income logic
  void _saveExpense() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar("Invalid", "Please enter a valid amount");
      return;
    }

    homeController.addTransaction(TransactionModel(
      amount: amount,
      category: selectedCategory ?? 'Uncategorized',
      date: selectedDate,
      description: descriptionController.text.trim(),
      type: 'Expense',
    ));
    Get.back();
  }

  void _saveIncome() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar("Invalid", "Please enter a valid amount");
      return;
    }

    homeController.addTransaction(TransactionModel(
      amount: amount,
      category: selectedCategory ?? 'Uncategorized',
      date: selectedDate,
      description: descriptionController.text.trim(),
      type: 'Income',
    ));
    Get.back();
  }

  // Reusable input decoration
  InputDecoration _inputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      filled: true,
      fillColor: AppColorHelper().backgroundColor.withOpacity(0.15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(
            color: type == 'Expense'
                ? AppColorHelper().borrowColor
                : AppColorHelper().lendColor,
            width: 1.3),
      ),
      labelStyle:
          textStyle(15, AppColorHelper().primaryTextColor, FontWeight.w500),
    );
  }

  final List<Map<String, dynamic>> categoryIcons = [
    {
      'name': 'Food',
      'icon': Icons.fastfood_outlined,
      'color': AppColorHelper().foodColor,
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
      'name': 'Salary',
      'icon': Icons.attach_money_rounded,
      'color': AppColorHelper().salaryColor,
    },
    {
      'name': 'Savings',
      'icon': Icons.account_balance_wallet_outlined,
      'color': AppColorHelper().savingsColor,
    },
    {
      'name': 'Miscellaneous',
      'icon': Icons.star,
      'color': AppColorHelper().missColor,
    },
  ];
}
