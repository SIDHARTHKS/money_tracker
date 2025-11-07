import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/controller/savings_controller.dart';
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
                        AppColorHelper().primaryColor.withValues(alpha: 0.5),
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
                SavingsBottomsheet.show();
              },
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColorHelper().primaryColor.withValues(alpha: 0.4),
                      AppColorHelper().primaryColor.withValues(alpha: 0.4),
                      AppColorHelper().primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          AppColorHelper().primaryColor.withValues(alpha: 0.18),
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
                  border: Border.all(
                    color: AppColorHelper().borderColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appText(
                      "Add Savings",
                      color: AppColorHelper().primaryTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    width(15),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColorHelper().primaryTextColor,
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
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: controller.savingsList.length,
              itemBuilder: (context, index) {
                var saving = controller.savingsList[index];
                return Obx(() {
                  bool isExpanded = controller.expandedIndex.value == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        controller.expandedIndex.value =
                            isExpanded ? -1 : index; // toggle expand
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColorHelper().cardColor.withOpacity(0.95),
                              AppColorHelper().cardColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColorHelper()
                                .borderColor
                                .withValues(alpha: 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColorHelper().cardColor.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            Row(
                              children: [
                                width(20),
                                appText(
                                  DateHelper()
                                      .formatTransactionDate(saving.date),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColorHelper()
                                      .primaryTextColor
                                      .withValues(alpha: 0.6),
                                ),
                                const Spacer(),
                                appText(
                                  "+ ${saving.amount}",
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppColorHelper()
                                      .primaryColor
                                      .withValues(alpha: 0.5),
                                ),
                                width(10),
                                AnimatedRotation(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOut,
                                  turns: isExpanded ? 0.5 : 0,
                                  child: Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 18,
                                    color: AppColorHelper()
                                        .primaryTextColor
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),

                            // Expanded area
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 22, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                            saving.note?.isNotEmpty == true
                                                ? saving.note!
                                                : "- -",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColorHelper()
                                                .primaryTextColor
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height(10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: errorGradientButtonContainer(
                                        appText(
                                          "Remove",
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColorHelper()
                                              .primaryTextColor
                                              .withValues(alpha: 0.8),
                                        ),
                                        radius: 10,
                                        height: 35,
                                        width: 110,
                                        onPressed: () {
                                          controller.deleteSavings(saving.key);
                                          controller.expandedIndex.value = -1;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 350),
                              sizeCurve: Curves.easeInOut,
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
            onTap: () => SavingsBottomsheet.show(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColorHelper().cardColor3,
                    AppColorHelper().cardColor3.withValues(alpha: 0.5),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorHelper().cardColor3.withValues(alpha: 0.45),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(0, 8), // subtle bottom shadow
                  ),
                ],
                border: Border.all(
                  color: AppColorHelper().cardColor3.withValues(alpha: 0.1),
                  width: 1.2,
                ),
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.add,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColorHelper().primaryColor.withValues(alpha: 0.35),
            AppColorHelper().primaryColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: AppColorHelper().borderColor.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColorHelper().primaryColor.withValues(alpha: 0.18),
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
