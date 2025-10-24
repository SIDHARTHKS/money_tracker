import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/helper/app_message.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/model/ledger_model.dart';
import 'package:tracker/view/widget/common_widget.dart';
import 'package:tracker/view/widget/text/app_text.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        type == "Lend" ? colorHelper.lendColor : colorHelper.borrowColor;

    return InputDecoration(
      prefixIcon: icon != null
          ? Icon(icon, color: activeColor.withOpacity(0.85))
          : null,
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: isDark
          ? activeColor.withOpacity(0.08)
          : activeColor.withOpacity(0.06),
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
        borderSide: BorderSide(color: activeColor, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                  Container(
                    decoration: BoxDecoration(
                      color: colorHelper.primaryColorLight.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        _typeButton("Lend", colorHelper.lendColor),
                        width(10),
                        _typeButton("Borrow", colorHelper.borrowColor),
                      ],
                    ),
                  ),
                  height(20),

                  // Input Fields (reactive to type color)
                  TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: _modernInputDecoration("Amount",
                        icon: Icons.currency_rupee_rounded),
                  ),
                  height(12),
                  TextField(
                    controller: nameController,
                    decoration: _modernInputDecoration("Assign Name",
                        icon: Icons.person_outline_rounded),
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
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: _modernInputDecoration(
                      "Description (Optional)",
                      icon: Icons.notes_rounded,
                    ),
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
                        color: colorHelper.primaryColor.withOpacity(0.08),
                        borderColor: Colors.transparent,
                        width: 100,
                        height: 42,
                        onPressed: () => Navigator.pop(context),
                      ),
                      width(10),
                      buttonContainer(
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
