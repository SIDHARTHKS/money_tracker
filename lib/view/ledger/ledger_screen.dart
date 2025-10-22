import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/gen/assets.gen.dart';
import 'package:tracker/helper/app_string.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/model/ledger_model.dart';
import 'package:tracker/view/ledger/ledger_bottomsheet.dart';
import '../../controller/home_controller.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/date_helper.dart';
import '../widget/common_widget.dart';

class LedgerScreen extends AppBaseView<HomeController> {
  const LedgerScreen({super.key});

  @override
  Widget buildView() {
    final theme = Theme.of(Get.context!);
    return Obx(() {
      return appScaffold(
        canpop: true,
        extendBodyBehindAppBar: false,
        appBar: appBar(
          titleText: "Ledger",
          showbackArrow: true,
        ),
        floatingActionButton:
            controller.rxledger.isEmpty ? null : _floatingButton(),
        body: controller.rxledger.isEmpty ? _emptyContainer() : _buildBody(),
      );
    });
  }

  Padding _emptyContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appText(
              "Easily track the money you lend and borrow, all in one place.",
              color: AppColorHelper().primaryTextColor,
              fontSize: 35,
              fontWeight: FontWeight.w900),
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
                  color: AppColorHelper().primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appText("Start Adding",
                      color: AppColorHelper().textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                  width(15),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColorHelper().textColor,
                  )
                ],
              )),
            ),
          )
        ],
      ),
    );
  }

  FloatingActionButton _floatingButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
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
      label: Text(
        "Add Entry",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.3,
          color: AppColorHelper().textColor, // ensure good contrast
        ),
      ),
      icon: Icon(
        Icons.add_rounded,
        size: 26,
        color: AppColorHelper().textColor,
      ),
      backgroundColor: AppColorHelper().primaryColor.withOpacity(0.8),
      elevation: 2,
      highlightElevation: 6,
      splashColor: AppColorHelper().primaryColorLight.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
    );
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
                AppColorHelper().primaryColorDark,
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
                color: AppColorHelper().cardColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(15),
                // boxShadow: [
                //   BoxShadow(
                //     color:
                //         AppColorHelper().boxShadowColor.withValues(alpha: 0.1),
                //     blurRadius: 10,
                //     spreadRadius: 2,
                //     offset: const Offset(0, 0),
                //   ),
                // ],
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
        color: color ?? AppColorHelper().cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                color: AppColorHelper().cardColor,
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(icon, color: color),
                ),
                width(10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColorHelper().primaryTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              "$rupeeEmoji ${amount.toStringAsFixed(0)}",
              style: TextStyle(
                color: color,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fundSummaryWidget(Color bgclr, Color gradientClr, Color icnClr,
      String Icon, double difference) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
            height: 100,
            width: Get.width,
            decoration: BoxDecoration(
                color: bgclr,
                boxShadow: [
                  BoxShadow(
                    color: AppColorHelper().boxShadowColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gradientClr.withValues(alpha: 0.6),
                    gradientClr.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    width: 250,
                    height: 85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            AppColorHelper().cardColor.withValues(alpha: 0.1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 80,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: AppColorHelper()
                                  .cardColor
                                  .withValues(alpha: 0.7)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(
                              Icon,
                              color: icnClr,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: appText(difference.toString(),
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: AppColorHelper().textColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: appText("Overview",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColorHelper().textColor),
                  ),
                ],
              ),
            )));
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: islend
                                          ? AppColorHelper()
                                              .lendColor
                                              .withValues(alpha: 0.1)
                                          : AppColorHelper()
                                              .borrowColor
                                              .withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      spreadRadius:
                                          2, // 👈 adds uniform shadow spread
                                      offset: const Offset(
                                          0, 0), // 👈 centers the shadow evenly
                                    ),
                                  ],
                                  color: islend
                                      ? AppColorHelper()
                                          .cardColor
                                          .withValues(alpha: 0.4)
                                      : AppColorHelper()
                                          .cardColor
                                          .withValues(alpha: 0.4)),
                              child: islend
                                  ? Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Image.asset(
                                        Assets.icons.lend.path,
                                        color: AppColorHelper().lendColor,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Image.asset(
                                        Assets.icons.borrow.path,
                                        color: AppColorHelper().borrowColor,
                                      ),
                                    )),
                          width(12),
                          // Title & Category
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isToday
                                    ? appText(
                                        "Today",
                                        fontSize: 13,
                                        color: AppColorHelper()
                                            .primaryTextColor
                                            .withOpacity(0.6),
                                      )
                                    : appText(
                                        DateHelper.convertDateTimeToString(
                                            dateTime: tx.date),
                                        fontSize: 13,
                                        color: AppColorHelper()
                                            .primaryTextColor
                                            .withOpacity(0.6),
                                      ),
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
                                    height(6),
                                    appText(
                                      "Description",
                                      fontWeight: FontWeight.bold,
                                      color: AppColorHelper().primaryTextColor,
                                    ),
                                    height(4),
                                    appText(
                                      tx.description.isEmpty
                                          ? "No description"
                                          : tx.description,
                                      color: AppColorHelper().primaryTextColor,
                                    ),
                                    height(10),
                                    tx.name.isEmpty
                                        ? height(0)
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              appText(
                                                "Asignee",
                                                fontWeight: FontWeight.bold,
                                                color: AppColorHelper()
                                                    .primaryTextColor,
                                              ),
                                              height(4),
                                              appText(
                                                tx.name,
                                                color: AppColorHelper()
                                                    .primaryTextColor,
                                              ),
                                            ],
                                          ),
                                    height(10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FilledButton.icon(
                                        onPressed: () =>
                                            controller.deleteLedger(tx.key),
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: AppColorHelper().errorColor,
                                        ),
                                        label: appText("Remove",
                                            color: AppColorHelper().errorColor,
                                            fontWeight: FontWeight.w500),
                                        style: FilledButton.styleFrom(
                                          side: BorderSide(
                                            color: AppColorHelper()
                                                .errorColor
                                                .withValues(alpha: 0.1),
                                            width:
                                                1.5, // optional: border width
                                          ),
                                          backgroundColor: AppColorHelper()
                                              .errorColor
                                              .withValues(alpha: 0.1),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
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
}
