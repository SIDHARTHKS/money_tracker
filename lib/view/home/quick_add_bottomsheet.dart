import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/helper/app_message.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/model/transaction_model.dart';
import 'package:tracker/view/widget/formatter/amount_formatter.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import 'package:tracker/view/widget/textformfield/common_textfield.dart';
import '../../controller/home_controller.dart';
import '../../helper/sizer.dart';
import '../widget/common_widget.dart';

class QuickAddBottomsheet extends StatefulWidget {
  const QuickAddBottomsheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickAddBottomsheet(),
    );
  }

  @override
  State<QuickAddBottomsheet> createState() => _QuickAddBottomsheetState();
}

class _QuickAddBottomsheetState extends State<QuickAddBottomsheet> {
  final HomeController homeController = Get.find<HomeController>();
  final FocusNode amountFocusNode = FocusNode();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String type = 'Expense';
  String? selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Slight delay to focus amount field after opening
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) FocusScope.of(context).requestFocus(amountFocusNode);
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorHelper = AppColorHelper();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
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
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 18,
                      right: 18,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      top: 16,
                    ),
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight * 0.6,
                        maxHeight: constraints.maxHeight * 0.9,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top handle
                            Center(
                              child: Container(
                                width: 36,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 18),
                                decoration: BoxDecoration(
                                  color: colorHelper.primaryTextColor
                                      .withOpacity(0.25),
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
                            height(20),

                            // Amount input
                            CommonTextField(
                              controller: amountController,
                              focusNode:
                                  amountFocusNode, // pass the existing focus node
                              label: "Amount",
                              prefixIcon: Icons.currency_rupee_rounded,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                AmountFormatter(
                                  maxDigitsBeforeDecimal: 8,
                                  maxDigitsAfterDecimal: 2,
                                ),
                              ],
                            ),
                            height(20),

                            // Category
                            appText(
                              "Category",
                              fontWeight: FontWeight.w600,
                              color: colorHelper.primaryTextColor,
                            ),
                            height(10),
                            _categorySelector(),

                            height(25),

                            appText(
                              "Description",
                              fontWeight: FontWeight.w600,
                              color: colorHelper.primaryTextColor,
                            ),
                            height(8),

                            // Description
                            CommonTextField(
                              controller: descriptionController,
                              label: "Description ",
                              prefixIcon: Icons.currency_rupee_rounded,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                AmountFormatter(
                                  maxDigitsBeforeDecimal: 8,
                                  maxDigitsAfterDecimal: 2,
                                ),
                              ],
                            ),

                            height(15),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 160,
                                height: 46,
                                child: errorGradientButtonContainer(
                                  appText(
                                    type == 'Expense'
                                        ? "Save Expense"
                                        : "Save Income",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: AppColorHelper()
                                      .primaryColor
                                      .withValues(alpha: 0.1),
                                  onPressed: _onSavePressed,
                                ),
                              ),
                            ),
                            height(8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categorySelector() {
    final colorHelper = AppColorHelper();

    return SizedBox(
      height: 100, // little extra space so shadow isn't clipped
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
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
