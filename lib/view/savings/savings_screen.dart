import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/controller/savings_controller.dart';
import 'package:tracker/gen/assets.gen.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/view/savings/savings_bottomsheet.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/date_helper.dart';
import '../widget/common_widget.dart';

class SavingsScreen extends AppBaseView<SavingsController> {
  const SavingsScreen({super.key});

  @override
  Widget buildView() {
    return Obx(() {
      return appScaffold(
          canpop: true,
          extendBodyBehindAppBar: false,
          appBar: appBar(
            titleText: "Savings",
            showbackArrow: true,
          ),
          body:
              controller.savingsList.isEmpty ? _emptyContainer() : _buildBody(),
          bottomNavigationBar:
              controller.savingsList.isEmpty ? null : _button());
    });
  }

  Padding _emptyContainer() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Every coin counts ... keep track of your ",
                      style: textStyle(
                        35,
                        AppColorHelper().primaryTextColor,
                        FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: "Savings",
                      style: textStyle(
                        35,
                        AppColorHelper().primaryColor,
                        FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: " with ease.",
                      style: textStyle(
                        35,
                        AppColorHelper().primaryTextColor,
                        FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left, // important for multiline
              ),
            ),
            Center(
              child: Lottie.asset(
                'assets/lottie/savings.json',
                fit: BoxFit.contain,
                repeat: false,
                height: 400,
                width: 400,
              ),
            ),
            height(20),
            GestureDetector(
              onTap: () {
                SavingsBottomsheet.show(Get.context!);
              },
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  color: AppColorHelper().primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appText(
                      "Add Savings",
                      color: AppColorHelper().textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    width(15),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColorHelper().textColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildBody() {
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              itemCount: controller.savingsList.length,
              itemBuilder: (context, index) {
                var saving = controller.savingsList[index];
                return Obx(() {
                  // Check if this item is expanded
                  bool isExpanded = controller.expandedIndex.value == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0),
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
                          border: Border.all(
                              color: AppColorHelper()
                                  .borderColor
                                  .withValues(alpha: 0.1)),
                          color:
                              AppColorHelper().cardColor.withValues(alpha: 0.6),
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
                                  color: AppColorHelper()
                                      .primaryTextColor
                                      .withValues(alpha: 0.5),
                                ),
                                const Spacer(),
                                appText(
                                  "+ ${saving.amount}",
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: AppColorHelper()
                                      .primaryColor
                                      .withValues(alpha: 0.6),
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
                                          height(5),
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.star_fill,
                                                  size: 10,
                                                  color: AppColorHelper()
                                                      .primaryTextColor
                                                      .withValues(alpha: 0.5)),
                                              width(10),
                                              Flexible(
                                                child: appText(
                                                  saving.note != ""
                                                      ? saving.note!
                                                      : "- -",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColorHelper()
                                                      .primaryTextColor
                                                      .withValues(alpha: 0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: buttonContainer(
                                              height: 35,
                                              width: 100,
                                              color: AppColorHelper().cardColor,
                                              borderColor: AppColorHelper()
                                                  .errorBorderColor
                                                  .withValues(alpha: 0.6),
                                              onPressed: () {
                                                controller
                                                    .deleteSavings(saving.key);
                                                controller.expandedIndex.value =
                                                    -1;
                                              },
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  appText(
                                                    "Remove",
                                                    fontSize: 10,
                                                    color: AppColorHelper()
                                                        .errorColor
                                                        .withValues(alpha: 0.6),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ],
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

  Row _button() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0, left: 15, right: 15),
          child: GestureDetector(
              onTap: () => SavingsBottomsheet.show(Get.context!),
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35), // shadow color
                          blurRadius: 50, // softness
                          spreadRadius: 5, // size of shadow
                          offset: const Offset(0, 0), // shadow position
                        ),
                      ],
                      shape: BoxShape.circle,
                      color: AppColorHelper().primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      CupertinoIcons.add,
                      size: 35,
                      color: AppColorHelper().textColor,
                    ),
                  ))),
        ),
      ],
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
