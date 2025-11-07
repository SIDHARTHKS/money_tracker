import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/helper/app_message.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/model/ledger_model.dart';
import 'package:tracker/view/widget/common_widget.dart';
import 'package:tracker/view/widget/formatter/amount_formatter.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import 'package:tracker/view/widget/textformfield/common_textfield.dart';

import '../../controller/home_controller.dart';

class LedgerBottomsheet extends StatefulWidget {
  const LedgerBottomsheet({super.key});

  @override
  State<LedgerBottomsheet> createState() => _LedgerBottomsheetState();
}

class _LedgerBottomsheetState extends State<LedgerBottomsheet> {
  final HomeController homeController = Get.find<HomeController>();

  String type = 'Lend';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColorHelper().primaryColorLight,
              onPrimary: AppColorHelper().backgroundColor,
              onSurface: AppColorHelper().primaryTextColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  // void _saveData() {
  //   Navigator.pop(context, {
  //     "type": type,
  //     "amount": amountController.text,
  //     "name": nameController.text,
  //     "date": selectedDate,
  //     "description": descriptionController.text,
  //   });
  // }
  void _saveLend() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      showErrorSnackbar(message: "Please enter a valid amount");
      return;
    }
    homeController.addLedger(LedgerModel(
      amount: amount,
      date: selectedDate,
      description: descriptionController.text.trim(),
      name: nameController.text,
      type: 'lend',
    ));
    Get.back();
  }

  void _saveBorrow() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar("Invalid", "Please enter a valid amount");
      return;
    }
    homeController.addLedger(LedgerModel(
      amount: amount,
      date: selectedDate,
      description: descriptionController.text.trim(),
      name: nameController.text,
      type: 'borrow',
    ));
    Get.back();
  }

  InputDecoration _modernInputDecoration(String label,
      {IconData? icon, String? hintText}) {
    final colorHelper = AppColorHelper();

    return InputDecoration(
      hintText: label,
      labelText: "",
      hintStyle: textStyle(12,
          colorHelper.primaryTextColor.withValues(alpha: 0.5), FontWeight.w400),
      prefixIcon:
          Icon(Icons.date_range_outlined, color: colorHelper.primaryTextColor),
      filled: true,
      fillColor: colorHelper.primaryColor.withValues(alpha: 0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorHelper.borderColor.withValues(alpha: 0.05),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorHelper.primaryColor.withValues(alpha: 0.05),
          width: 1.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorHelper = AppColorHelper();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        decoration: BoxDecoration(
          color: colorHelper.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22).copyWith(top: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: colorHelper.primaryTextColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: appText(
                          "Add Ledger Entry",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorHelper.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  height(20),

                  // Type Toggle
                  _buildTypeSwitcher(colorHelper),
                  height(20),

                  // Input Fields (reactive to type color)
                  CommonTextField(
                    controller: amountController,
                    label: "Amount",
                    prefixIcon: Icons.currency_rupee_rounded,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  height(12),

                  CommonTextField(
                    controller: nameController,
                    label: "Assign Name",
                    prefixIcon: Icons.person_outline_rounded,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  height(12),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: _modernInputDecoration(
                          "Select Date",
                          icon: Icons.date_range_outlined,
                          hintText:
                              "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                        ),
                      ),
                    ),
                  ),
                  height(12),
                  CommonTextField(
                    controller: nameController,
                    label: "Description",
                    maxLines: 2,
                    prefixIcon: Icons.notes_rounded,
                  ),
                  height(26),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buttonContainer(
                        appText(
                          "Cancel",
                          color: colorHelper.primaryTextColor.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        color: colorHelper.primaryColor.withOpacity(0.05),
                        borderColor:
                            AppColorHelper().borderColor.withValues(alpha: 0.1),
                        width: 100,
                        height: 42,
                        onPressed: () => Navigator.pop(context),
                      ),
                      width(10),
                      gradientButtonContainer(
                        appText(
                          "Save",
                          color: AppColorHelper().primaryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        width: 100,
                        height: 42,
                        color: type == "Lend"
                            ? colorHelper.lendColor
                            : colorHelper.borrowColor,
                        onPressed: () {
                          type == "Lend" ? _saveLend() : _saveBorrow();
                        },
                      ),
                    ],
                  ),
                  height(10),
                ],
              ),
            ),
          ),
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
            alignment:
                type == 'Lend' ? Alignment.centerLeft : Alignment.centerRight,
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
              Expanded(child: _buildTypeChip('Lend', colorHelper.borrowColor)),
              Expanded(child: _buildTypeChip('Borrow', colorHelper.lendColor)),
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

  Expanded _typeButton(String label, Color activeColor) {
    final colorHelper = AppColorHelper();
    final bool selected = type == label;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? activeColor.withOpacity(0.9) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => type = label),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: appText(label,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: selected
                      ? colorHelper.primaryTextColor
                      : colorHelper.primaryTextColor),
            ),
          ),
        ),
      ),
    );
  }
}
