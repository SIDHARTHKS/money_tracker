import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/gen/assets.gen.dart';
import 'package:tracker/helper/app_string.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/model/ledger_model.dart';
import 'package:tracker/view/ledger/ledger_bottomsheet.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import '../../controller/home_controller.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/date_helper.dart';
import '../widget/common_widget.dart';

class LedgerScreen extends AppBaseView<HomeController> {
  const LedgerScreen({super.key});

  @override
  Widget buildView() {
    return Obx(() {
      return appScaffold(
        canpop: true,
        extendBodyBehindAppBar: false,
        appBar: appBar(
          titleText: "Ledger",
          showbackArrow: true,
        ),
        body: controller.rxledger.isEmpty ? _emptyContainer() : _buildBody(),
        bottomNavigationBar:
            controller.rxledger.isEmpty ? null : _floatingButton(),
      );
    });
  }

  Widget _buildBody() {
    bool isPositive = controller.isPositive();
    return RefreshIndicator(
      onRefresh: () async {},
      color: AppColorHelper().primaryColor,
      child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16, bottom: 90),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summarySection(isPositive),
              _lendAndBorrowSection(),
              _sortedLedger()
            ],
          )),
    );
  }

  Column _summarySection(bool isPositive) {
    return Column(
      children: [
        isPositive
            ? _fundSummaryWidget(
                AppColorHelper().primaryColor,
                AppColorHelper().primaryColor,
                AppColorHelper().lendColor,
                Assets.icons.toGet.path,
                controller.rxledgerDifference)
            : _fundSummaryWidget(
                AppColorHelper().borrowColor,
                AppColorHelper().borrowColor.withValues(alpha: 0.6),
                AppColorHelper().borrowColor,
                Assets.icons.toGive.path,
                controller.rxledgerDifference),
      ],
    );
  }

  ListView _sortedLedger() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.sortedLedgersByDate.length,
        itemBuilder: (context, index) {
          var ledgerList = controller.sortedLedgersByDate[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColorHelper().borderColor.withValues(alpha: 0.1)),
                color: AppColorHelper().cardColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        width(20),
                        appText(
                            DateHelper()
                                .formatTransactionDate(ledgerList[0].date),
                            textAlign: TextAlign.start,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColorHelper().primaryTextColor),
                      ],
                    ),
                    _ledgerList(ledgerList, parentIndex: index),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _materialCard({required Widget child, Color? color, double? height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color!.withValues(alpha: 0.18),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }

  Widget _lendAndBorrowSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: _materialCard(
              color: AppColorHelper().cardColor.withOpacity(0.7),
              child: _summaryCard(
                title: "Total Lend",
                amount: controller.rxLendSum.value,
                color: AppColorHelper().lendColor,
                icon: Assets.icons.lend.path,
                gradient: LinearGradient(
                  colors: [
                    AppColorHelper().lendColor.withOpacity(0.0),
                    AppColorHelper().lendColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          width(10),
          Expanded(
            child: _materialCard(
              color: AppColorHelper().cardColor.withOpacity(0.7),
              child: _summaryCard(
                title: "Total Borrow",
                amount: controller.rxBorrowSum.value,
                color: AppColorHelper().borrowColor,
                icon: Assets.icons.borrow.path,
                gradient: LinearGradient(
                  colors: [
                    AppColorHelper().borrowColor.withOpacity(0.0),
                    AppColorHelper().borrowColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required double amount,
    required Color color,
    required String icon,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: AppColorHelper().borderColor.withValues(alpha: 0.1)),
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(icon, color: color),
                ),
                width(10),
                Expanded(
                  child: appText(
                    title,
                    color: AppColorHelper().primaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          height(14),
          Center(
            child: appText(
              "$rupeeEmoji ${amount.toStringAsFixed(0)}",
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fundSummaryWidget(
    Color bgclr,
    Color gradientClr,
    Color icnClr,
    String iconPath,
    double difference,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(seconds: 8),
        curve: Curves.linear,
        builder: (context, value, child) {
          return Container(
            height: 110,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradientClr.withValues(alpha: 0.35),
                  gradientClr.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: gradientClr.withValues(alpha: 0.18),
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Icon + Balance
                  Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColorHelper()
                                  .cardColor
                                  .withValues(alpha: 0.95),
                              AppColorHelper().cardColor.withValues(alpha: 0.4),
                            ],
                          ),
                          border: Border.all(
                            color: icnClr.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: icnClr.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image.asset(
                            iconPath,
                            color: icnClr,
                          ),
                        ),
                      ),
                      width(25),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(
                            "₹ ${difference.toStringAsFixed(0)}",
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColorHelper().textColor,
                          ),
                          const SizedBox(height: 6),
                          appText(
                            "Balance",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColorHelper()
                                .primaryTextColor
                                .withOpacity(0.6),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Optional trailing tag
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColorHelper().cardColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: appText(
                      "Overview",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColorHelper().primaryTextColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onEnd: () {
          // loop animation for infinite smooth movement
          Future.delayed(const Duration(milliseconds: 500), () {
            // triggers rebuild for looping gradient
          });
        },
      ),
    );
  }

  ListView _ledgerList(List<LedgerModel> ledger, {required int parentIndex}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ledger.length,
      itemBuilder: (context, index) {
        final tx = ledger[index];
        return Obx(() {
          final isExpanded = controller.expandedIndexMap[parentIndex] == index;
          final islend = tx.type == 'lend';
          final Color baseColor = islend
              ? AppColorHelper().lendColor
              : AppColorHelper().borrowColor;
          bool isToday =
              DateHelper.convertDateTimeToString(dateTime: tx.date) ==
                  DateHelper.convertDateTimeToString(dateTime: DateTime.now());

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(16),
              color: AppColorHelper().cardColor.withValues(alpha: 0.1),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  final groupIndex = parentIndex; // we'll pass this below
                  if (controller.expandedIndexMap[groupIndex] == index) {
                    controller.expandedIndexMap.remove(groupIndex);
                  } else {
                    controller.expandedIndexMap[groupIndex] = index;
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColorHelper().cardColor.withValues(alpha: 0.1),
                    border: isExpanded
                        ? Border.all(
                            color: AppColorHelper()
                                .borderColor
                                .withValues(alpha: 0.05))
                        : Border.all(
                            color: AppColorHelper()
                                .borderColor
                                .withValues(alpha: 0.05)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Main Tile
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gradient Circle Icon
                          Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: islend
                                      ? AppColorHelper()
                                          .lendColor
                                          .withValues(alpha: 0.6)
                                      : AppColorHelper()
                                          .borrowColor
                                          .withValues(alpha: 0.6)),
                              child: islend
                                  ? Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Image.asset(
                                        Assets.icons.lend.path,
                                        color: AppColorHelper().textColor,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Image.asset(
                                        Assets.icons.borrow.path,
                                        color: AppColorHelper().textColor,
                                      ),
                                    )),
                          width(12),
                          // Title & Category
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                appText(
                                  tx.name != "" ? tx.name : "**",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColorHelper()
                                      .primaryTextColor
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                          // Amount
                          appText(
                            (tx.type == 'Expense' ? "- ₹ " : "+ ₹ ") +
                                tx.amount.toStringAsFixed(2),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: baseColor,
                          ),
                        ],
                      ),

                      // Expanded Details
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: isExpanded
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                        color: AppColorHelper()
                                            .borderColor
                                            .withOpacity(0.05)),
                                    tx.description.isEmpty
                                        ? height(0)
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              height(6),
                                              appText(
                                                "Description",
                                                fontWeight: FontWeight.bold,
                                                color: AppColorHelper()
                                                    .primaryTextColor
                                                    .withValues(alpha: 0.5),
                                              ),
                                              height(4),
                                              appText(
                                                tx.description,
                                                color: AppColorHelper()
                                                    .borderColor
                                                    .withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: errorGradientButtonContainer(
                                        height: 35,
                                        width: 100,
                                        color: AppColorHelper()
                                            .errorColor
                                            .withValues(alpha: 0.1),
                                        onPressed: () {
                                          controller.deleteLedger(tx.key);
                                          controller.expandedIndexMap.clear();
                                        },
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            appText(
                                              "Remove",
                                              fontSize: 10,
                                              color: AppColorHelper()
                                                  .primaryTextColor
                                                  .withValues(alpha: 0.9),
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
            ),
          );
        });
      },
    );
  }

  Padding _floatingButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0, left: 15, right: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              await showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                backgroundColor: AppColorHelper().backgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                builder: (context) => LedgerBottomsheet(),
              );
            },
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
        ],
      ),
    );
  }

  Padding _emptyContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "Easily track the money you lend and borrow, all in one place.",
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
          Center(
            child: Lottie.asset('assets/lottie/ledger.json',
                fit: BoxFit.contain, repeat: false, height: 400, width: 400),
          ),
          height(5),
          GestureDetector(
            onTap: () async {
              await showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                backgroundColor: AppColorHelper().backgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                builder: (context) => LedgerBottomsheet(),
              );
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
                    "Start Adding",
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
      ),
    );
  }
}
