import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tracker/helper/app_message.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/model/salary_model.dart';
import 'package:tracker/view/widget/formatter/amount_formatter.dart';
import 'package:tracker/view/widget/textformfield/common_textfield.dart';
import '../widget/common_widget.dart';

class IncomeBottomsheet extends StatefulWidget {
  final String title;
  final double? initialValue;
  final Box<SalaryModel>? salaryBox;

  const IncomeBottomsheet(
      {super.key,
      this.title = "Set Your Goal",
      this.initialValue,
      this.salaryBox});

  @override
  State<IncomeBottomsheet> createState() => _IncomeBottomsheetState();

  static Future<double?> show(BuildContext context,
      {String title = "Set Your Goal",
      double? initialValue,
      Box<SalaryModel>? salaryBox}) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IncomeBottomsheet(
        title: title,
        initialValue: initialValue,
        salaryBox: salaryBox,
      ),
    );
  }
}

class _IncomeBottomsheetState extends State<IncomeBottomsheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.initialValue?.toString() ?? "");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final amount = double.tryParse(_controller.text.trim());
    if (amount != null) {
      Navigator.pop(context, amount);
    } else {
      showErrorSnackbar(message: "Enter a valid amount");
      Navigator.pop(context, amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorHelper = AppColorHelper();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    var previousAmnt = widget.initialValue;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // top drag handle
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: colorHelper.primaryTextColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Title
                appText(
                  widget.title,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorHelper.primaryTextColor,
                ),
                height(20),

                // TextField
                CommonTextField(
                  controller: _controller,
                  label: "Enter your goal",
                  prefixIcon: Icons.currency_rupee_rounded,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    AmountFormatter(
                        maxDigitsBeforeDecimal: 8, maxDigitsAfterDecimal: 2),
                  ],
                  fillColor: isDark
                      ? colorHelper.primaryColorDark.withOpacity(0.15)
                      : colorHelper.primaryColorLight.withOpacity(0.08),
                  fontSize: 16,
                ),

                height(26),

                // Action buttons
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
                      onPressed: () {
                        final amount = double.tryParse(_controller.text.trim());
                        if (widget.initialValue == amount) {
                          Navigator.pop(context, amount);
                        } else {
                          Navigator.pop(context, previousAmnt);
                        }
                      },
                    ),
                    width(10),
                    buttonContainer(
                      appText(
                        "Save",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      width: 100,
                      height: 42,
                      color: colorHelper.primaryColor,
                      onPressed: _onSave,
                    ),
                  ],
                ),
                height(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
