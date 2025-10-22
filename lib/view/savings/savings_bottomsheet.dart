import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/controller/savings_controller.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/view/widget/common_widget.dart';

import '../../helper/app_message.dart';

class SavingsBottomsheet extends StatelessWidget {
  const SavingsBottomsheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColorHelper().cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => const SavingsBottomsheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SavingsController>();
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top handle bar ───────────────────────────
          Center(
            child: Container(
              width: 50,
              height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // ── Title ───────────────────────────
          appText(
            "Add Savings",
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColorHelper().textColor,
          ),
          height(15),

          // ── Amount Input ───────────────────────────
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter amount",
              filled: true,
              fillColor: AppColorHelper().primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
            ),
          ),
          height(20),

          // ── Note Input ───────────────────────────
          TextField(
            controller: noteController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Enter note",
              filled: true,
              fillColor: AppColorHelper().primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.note_alt_outlined),
            ),
          ),
          height(25),

          // ── Save Button ───────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                final note = noteController.text.trim();

                if (amount != null && amount > 0) {
                  controller.addSavings(amount, note);
                  Get.back();
                } else {
                  showErrorSnackbar(message: "Invalid Amount");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorHelper().primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          height(10),
        ],
      ),
    );
  }
}
