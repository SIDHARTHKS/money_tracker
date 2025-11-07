import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/controller/savings_controller.dart';
import 'package:tracker/helper/app_message.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/view/widget/common_widget.dart';

class SavingsBottomsheet extends StatefulWidget {
  const SavingsBottomsheet({super.key});

  static Future<void> show() {
    return showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SavingsBottomsheet(),
    );
  }

  @override
  State<SavingsBottomsheet> createState() => _SavingsBottomsheetState();
}

class _SavingsBottomsheetState extends State<SavingsBottomsheet> {
  final controller = Get.find<SavingsController>();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final FocusNode amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(amountFocus);
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorHelper = AppColorHelper();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: colorHelper.cardColor.withOpacity(0.95),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
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
                            "Add Savings",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colorHelper.primaryTextColor,
                          ),
                        ),
                        height(20),

                        // Amount field
                        TextField(
                          focusNode: amountFocus,
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: _inputDecoration(
                            "Enter amount",
                            prefixIcon: Icons.currency_rupee_rounded,
                            colorHelper: colorHelper,
                          ),
                        ),
                        height(18),

                        // Note field
                        TextField(
                          controller: noteController,
                          decoration: _inputDecoration(
                            "Enter note (optional)",
                            prefixIcon: Icons.note_alt_outlined,
                            colorHelper: colorHelper,
                          ),
                        ),
                        height(25),

                        // Save button
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 120,
                            child: buttonContainer(
                              appText(
                                "Save",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              color: colorHelper.lendColor,
                              onPressed: _onSavePressed,
                            ),
                          ),
                        ),
                        height(10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint, {
    required IconData prefixIcon,
    required AppColorHelper colorHelper,
  }) {
    final fillColor = colorHelper.primaryColor.withOpacity(0.08);
    final focusColor = colorHelper.lendColor.withOpacity(0.2);

    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(prefixIcon,
          color: colorHelper.primaryTextColor.withOpacity(0.7)),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusColor, width: 1.3),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      hintStyle: TextStyle(
        color: colorHelper.primaryTextColor.withOpacity(0.6),
        fontSize: 14,
      ),
    );
  }

  void _onSavePressed() {
    final amount = double.tryParse(amountController.text.trim());
    final note = noteController.text.trim();

    if (amount == null || amount <= 0) {
      showErrorSnackbar(message: "Please enter a valid amount");
      return;
    }

    controller.addSavings(amount, note);
    Get.back();
  }
}
