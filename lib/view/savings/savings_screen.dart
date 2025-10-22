import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/controller/savings_controller.dart';
import 'package:tracker/gen/assets.gen.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/view/savings/savings_bottomsheet.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/date_helper.dart';
import '../widget/common_widget.dart';

class SavingsScreen extends AppBaseView<SavingsController> {
  const SavingsScreen({super.key});

  @override
  Widget buildView() {
    final theme = Theme.of(Get.context!);
    return appScaffold(
        canpop: true,
        extendBodyBehindAppBar: false,
        appBar: appBar(
          titleText: "Savings",
          showbackArrow: true,
        ),
        body: _buildBody(theme),
        bottomNavigationBar: _button());
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.only(top: 16, bottom: 10, left: 10.0, right: 10.0),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Obx(() {
        return Column(
          children: [
            _rippleContainer(),
            height(30),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              itemCount: controller.savingsList.length,
              itemBuilder: (context, index) {
                var saving = controller.savingsList[index];
                return Obx(() {
                  // Check if this item is expanded
                  bool isExpanded = controller.expandedIndex.value == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (isExpanded) {
                          controller.expandedIndex.value = -1; // collapse
                        } else {
                          controller.expandedIndex.value = index; // expand
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColorHelper()
                              .primaryColor
                              .withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row with date

                            Row(
                              children: [
                                width(20),
                                appText(
                                  DateHelper()
                                      .formatTransactionDate(saving.date),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColorHelper().textColor,
                                ),
                                const Spacer(),
                                appText(
                                  "+ ${saving.amount}",
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: AppColorHelper().textColor,
                                ),
                                width(10)
                              ],
                            ),

                            // Expanded note
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: isExpanded
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          height(20),
                                          saving.note != ""
                                              ? Image.asset(
                                                  Assets.icons.star.path,
                                                  width: 15,
                                                  height: 15,
                                                  color: AppColorHelper()
                                                      .cardColor,
                                                )
                                              : height(0),
                                          height(10),
                                          appText(
                                            saving.note ?? "No note",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: AppColorHelper().textColor,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: FilledButton.icon(
                                              onPressed: () => controller
                                                  .deleteSavings(saving.key),
                                              icon: Icon(
                                                Icons.close,
                                                size: 20,
                                                color:
                                                    AppColorHelper().errorColor,
                                              ),
                                              label: appText("Remove",
                                                  color: AppColorHelper()
                                                      .errorColor,
                                                  fontWeight: FontWeight.w600),
                                              style: FilledButton.styleFrom(
                                                side: BorderSide(
                                                  color: AppColorHelper()
                                                      .errorColor
                                                      .withValues(alpha: 0.1),
                                                  width:
                                                      1.5, // optional: border width
                                                ),
                                                backgroundColor:
                                                    AppColorHelper()
                                                        .cardColor
                                                        .withValues(alpha: 0.4),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            )
          ],
        );
      }),
    );
  }

  Padding _button() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, left: 20),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: ElevatedButton.icon(
              onPressed: () => SavingsBottomsheet.show(Get.context!),
              icon: const Icon(Icons.add_rounded, size: 24),
              label: const Text("Add Savings"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorHelper().primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _rippleContainer() {
    return Container(
      height: 120,
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColorHelper().primaryColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(60),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Ripple layers
          Positioned(
            left: 5,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                for (var i = 0; i < 7; i++)
                  Container(
                    width: 350 - (i * 50),
                    height: 350 - (i * 50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColorHelper()
                          .primaryColor
                          .withOpacity(0.05 + (i * 0.1)),
                    ),
                  ),
              ],
            ),
          ),
          // Foreground
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColorHelper().cardColor.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Lottie.asset(
                    'assets/lottie/piggy.json',
                    fit: BoxFit.contain,
                    repeat: false,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      size: 30,
                      color: AppColorHelper().textColor.withOpacity(0.99),
                    ),
                    width(5),
                    appText(
                      controller.totalSavings.toString(),
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColorHelper().textColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
