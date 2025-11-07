import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tracker/controller/home_controller.dart';
import 'package:tracker/helper/app_message.dart';
import 'package:tracker/helper/app_string.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/date_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/model/transaction_model.dart';
import 'package:tracker/view/widget/formatter/amount_formatter.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import 'package:tracker/view/widget/common_widget.dart';

import '../widget/textformfield/common_textfield.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with TickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxBool rxExpanded = false.obs;
  final ScrollController _scrollController = ScrollController();

  final double _horizontalPadding = 10;
  final double _fieldSpacing = 20;

  String type = 'Expense';
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = 'Miscellaneous';
    ever(rxExpanded, (isOpen) {
      if (isOpen == true) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorHelper = AppColorHelper();
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: colorHelper.backgroundColor,
      appBar: appBar(
        titleText: "Add Transaction",
        showbackArrow: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus;
            selectedDate = DateTime.now();
            rxExpanded.value = false;
          },
          behavior: HitTestBehavior.translucent,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _moneyDetails(),
                height(_fieldSpacing),
                _buildTypeSwitcher(colorHelper),
                height(_fieldSpacing),

                // Amount Input
                CommonTextField(
                  controller: amountController,
                  label: "Amount",
                  prefixIcon: Icons.currency_rupee_rounded,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    AmountFormatter(
                      maxDigitsBeforeDecimal: 8,
                      maxDigitsAfterDecimal: 2,
                    ),
                  ],
                ),
                height(_fieldSpacing),

                // Category
                _sectionTitle("Category", colorHelper),
                height(8),
                _categorySelector(),
                height(_fieldSpacing),

                // Date
                _sectionTitle("Date", colorHelper),
                height(8),
                Obx(() => _dateSelector(now, colorHelper)),
                height(_fieldSpacing),

                // Description
                CommonTextField(
                  controller: descriptionController,
                  label: "Description",
                  prefixIcon: Icons.description_outlined,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    AmountFormatter(
                      maxDigitsBeforeDecimal: 8,
                      maxDigitsAfterDecimal: 2,
                    ),
                  ],
                ),
                height(28),

                // Save Button
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 150,
                    child: gradientButtonContainer(
                      appText(
                        type == 'Expense' ? "Save Expense" : "Save Income",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      color:
                          AppColorHelper().primaryColor.withValues(alpha: 0.1),
                      onPressed: _onSavePressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- money details ----
  Padding _moneyDetails() {
    final colorHelper = AppColorHelper();
    final balance = homeController.rxTotalbalance.value.toString();
    final digitsBeforeDecimal =
        balance.contains('.') ? balance.split('.')[0].length : balance.length;
    final fontSize = digitsBeforeDecimal < 7 ? 42.0 : 32.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorHelper.primaryColor.withValues(alpha: 0.25),
              colorHelper.cardColor.withValues(alpha: 0.15),
            ],
          ),
          border: Border.all(
            color: colorHelper.borderColor.withValues(alpha: 0.12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: colorHelper.primaryColor.withValues(alpha: 0.1),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 6), // gentle bottom glow
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.15),
              blurRadius: 6,
              spreadRadius: -2,
              offset: const Offset(0, -3), // subtle top light
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(12),
            appText(
              "Cash Balance",
              fontSize: 13,
              color: colorHelper.primaryTextColor.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  "$rupeeEmoji $balance",
                  fontSize: fontSize,
                  color: colorHelper.primaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            height(8),
            appText(
              "$rupeeEmoji ${homeController.rxTotalspend.value}",
              color: colorHelper.primaryTextColor.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(
              width: Get.width * 0.95,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Obx(() {
                  final spend = homeController.rxTotalspend.value;
                  final income = homeController.salary.value;
                  final ratio =
                      (income > 0) ? (spend / income).clamp(0.0, 1.0) : 0.0;

                  return LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                    value: ratio,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor:
                        AlwaysStoppedAnimation(colorHelper.progressbarclr),
                    minHeight: 8.5,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSwitcher(AppColorHelper colorHelper) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorHelper.cardColor3.withValues(alpha: 0.1),
        border: Border.all(
            color: AppColorHelper().borderColor.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColorHelper().boxShadowColor.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Sliding background highlight
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: type == 'Expense'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: (Get.width - 50) / 2, // or manually set width if needed
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: AppColorHelper().cardColor.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppColorHelper().boxShadowColor.withValues(alpha: 0.01),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: _buildTypeChip('Expense', colorHelper.borrowColor)),
              Expanded(child: _buildTypeChip('Income', colorHelper.lendColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, Color color) {
    return GestureDetector(
      onTap: () => setState(() => type = label),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: textStyle(
          15,
          AppColorHelper().primaryTextColor,
          FontWeight.w600,
        ),
        child: Center(child: Text(label)),
      ),
    );
  }

  Widget _categorySelector() {
    final colorHelper = AppColorHelper();

    return SizedBox(
      height: 100, // little extra space so shadow isn't clipped
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: homeController.categoryIcons.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        separatorBuilder: (_, __) => width(12),
        itemBuilder: (context, index) {
          final cat = homeController.categoryIcons[index];
          final isSelected = selectedCategory == cat['name'];
          final Color baseColor = cat['color'];
          final double expandedWidth = Get.width * 0.36;

          return GestureDetector(
            onTap: () => setState(() {
              selectedCategory = isSelected ? null : cat['name'];
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuart,
              width: isSelected ? expandedWidth : 70,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 14 : 10,
                vertical: isSelected ? 12 : 10,
              ),
              margin: const EdgeInsets.symmetric(vertical: 5),
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [
                          baseColor.withValues(alpha: 0.9),
                          baseColor.withValues(alpha: 0.7),
                        ]
                      : [
                          baseColor.withValues(alpha: 0.3),
                          baseColor.withValues(alpha: 0.15),
                        ],
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: baseColor.withValues(alpha: 0.45),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: const Offset(0, 8), // 👈 bottom shadow
                    ),
                ],
                border: Border.all(
                  color: isSelected
                      ? baseColor.withValues(alpha: 0.8)
                      : baseColor.withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      cat['icon'],
                      color: isSelected
                          ? AppColorHelper().textColor
                          : colorHelper.primaryTextColor.withValues(alpha: 0.9),
                      size: isSelected ? 22 : 26,
                    ),
                  ),
                  isSelected
                      ? AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          switchInCurve: Curves.easeOutQuart,
                          switchOutCurve: Curves.easeInCubic,
                          child: isSelected
                              ? Padding(
                                  key: ValueKey(cat['name']),
                                  padding: const EdgeInsets.only(left: 8),
                                  child: appText(
                                    cat['name'],
                                    color: AppColorHelper().textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        )
                      : width(0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dateSelector(DateTime now, AppColorHelper colorHelper) {
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: rxExpanded.value
          ? _calendar(firstDayOfMonth, lastDayOfMonth)
          : GestureDetector(
              onTap: () => rxExpanded.toggle(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          AppColorHelper().primaryColor.withValues(alpha: 0.1)),
                  color: colorHelper.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    width(8),
                    appText(
                      DateHelper()
                          .formatTransactionDate(selectedDate)
                          .toString(),
                      fontWeight: FontWeight.w600,
                      color: colorHelper.primaryTextColor,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _calendar(DateTime firstDay, DateTime lastDay) {
    final colorHelper = AppColorHelper();
    return Container(
      decoration: BoxDecoration(
        color: colorHelper.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar(
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: selectedDate,
        selectedDayPredicate: (day) => DateHelper.isSameDate(day, selectedDate),
        onDaySelected: (selected, _) {
          selectedDate = selected;
          rxExpanded.value = false;
        },
        availableGestures: AvailableGestures.none,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle:
              textStyle(15, colorHelper.primaryTextColor, FontWeight.w600),
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: colorHelper.primaryTextColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: colorHelper.primaryColor.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          selectedTextStyle:
              textStyle(14, colorHelper.textColor, FontWeight.w700),
          weekendTextStyle: textStyle(14,
              colorHelper.primaryTextColor.withOpacity(0.9), FontWeight.w500),
          defaultTextStyle: textStyle(14,
              colorHelper.primaryTextColor.withOpacity(0.9), FontWeight.w500),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, AppColorHelper colorHelper) => appText(
        title,
        fontWeight: FontWeight.w600,
        color: colorHelper.primaryTextColor,
      );

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
}
