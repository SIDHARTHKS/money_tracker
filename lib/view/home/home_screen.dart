import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/gen/assets.gen.dart';
import 'package:tracker/helper/app_string.dart';
import 'package:tracker/helper/navigation.dart';
import 'package:tracker/helper/route.dart';
import 'package:tracker/model/transaction_model.dart';
import 'package:tracker/view/home/income_bottomsheet.dart';
import 'package:tracker/view/home/quick_add_bottomsheet.dart';
import '../../controller/home_controller.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/date_helper.dart';
import '../../helper/sizer.dart';
import '../widget/common_widget.dart';

class HomeScreen extends AppBaseView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget buildView() => appScaffold(
        canpop: true,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: _buildBody(),
      );

  AppBar _buildAppBar() =>
      // customAppBar("Hi, ${controller.rxUserName} !", "sidhuks29@gmail.com");
      customAppBar("Money", "sidhuks29@hmail.com");

  Widget _buildBody() {
    final colorHelper = AppColorHelper();

    return Obx(
      () => appContainer(
        child: Stack(
          children: [
            // --- Main Scroll Content ---
            appContainer(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.only(bottom: 50), // leave space for button
                child: Column(
                  children: [
                    _moneyDetails(),
                    if (controller.rxTotalincome.value > 0) _incomeContainer(),
                    _transactionAndLedger(),
                    height(5),
                    controller.transactions.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colorHelper.cardColor.withValues(alpha: 0.99),
                                  colorHelper.cardColor.withValues(alpha: 0.85),
                                  colorHelper.cardColor.withValues(alpha: 0.8),
                                  colorHelper.cardColor.withValues(alpha: 0.75),
                                  colorHelper.cardColor.withValues(alpha: 0.6),
                                  colorHelper.cardColor.withValues(alpha: 0.5),
                                  colorHelper.cardColor.withValues(alpha: 0.0),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColorHelper()
                                      .boxShadowColor
                                      .withValues(alpha: 0.05),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: const Offset(0, -4), // shadow at top
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: colorHelper.cardColor,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      controller.transactions.isNotEmpty
                                          ? appText(
                                              "Recent Transactions",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  colorHelper.primaryTextColor,
                                            )
                                          : const SizedBox.shrink(),
                                      if (controller.transactions.isNotEmpty)
                                        _showAllButton(),
                                    ],
                                  ),
                                ),
                                height(10),
                                _sortedTransactions(),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              height(50),
                              controller.rxTotalbalance.value != 0.00
                                  ? appText("Tap + to add transactions",
                                      color: AppColorHelper().primaryTextColor,
                                      fontWeight: FontWeight.w500)
                                  : appText("Set a goal to add transactions",
                                      color: AppColorHelper()
                                          .primaryTextColor
                                          .withValues(alpha: 0.5),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                            ],
                          )
                  ],
                ),
              ),
            ),

            // --- Floating Button ---
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    context: Get.context!,
                    isScrollControlled: true,
                    backgroundColor: colorHelper.cardColor,
                    constraints:
                        BoxConstraints.expand(height: Get.height * 0.75),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    builder: (_) => const QuickAddBottomsheet(),
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
                        colorHelper.cardColor3,
                        colorHelper.cardColor3.withValues(alpha: 0.5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorHelper.cardColor3.withValues(alpha: 0.45),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 8), // subtle bottom shadow
                      ),
                    ],
                    border: Border.all(
                      color: colorHelper.cardColor3.withValues(alpha: 0.1),
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
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _showAllButton() => GestureDetector(
        onTap: () => navigateTo(viewAllPageRoute),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColorHelper().primaryColor.withValues(alpha: 0.3),
                    AppColorHelper().primaryColor.withValues(alpha: 0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorHelper().primaryColor.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColorHelper().borderColor.withValues(alpha: 0.01),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  appText(
                    "Show All",
                    color: AppColorHelper().primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                  width(6),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColorHelper().primaryColor.withValues(alpha: 0.7),
                          AppColorHelper().primaryColor.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: AppColorHelper().primaryTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Padding _incomeContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        width: Get.width,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColorHelper().cardColor3.withValues(alpha: 0.9),
              AppColorHelper().cardColor3.withValues(alpha: 0.3),
            ],
          ),
          color: AppColorHelper().cardColor3.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColorHelper().cardColor3.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColorHelper().cardColor3.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            appText(
              "Additional Income : ",
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
            appText(
              " + ${controller.rxTotalincome}",
              fontSize: 15,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
      ),
    );
  }

  Container _transactionAndLedger() {
    final colorHelper = AppColorHelper();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (controller.salary.value != 0.0)
            Flexible(
              child: fnButtons(
                  "Transaction",
                  "New Transaction",
                  Assets.icons.add.path,
                  colorHelper.transactionColor, () async {
                navigateTo(transactionPageRoute);
              }),
            ),
          Flexible(
            child: fnButtons("Ledger", "View Ledger", Assets.icons.ledger.path,
                colorHelper.ledgerColor, () {
              navigateTo(ledgerPageRoute);
            }),
          ),
          Flexible(
            child: fnButtons("Savings", "View Savings",
                Assets.icons.savings.path, colorHelper.savingsColor, () {
              navigateTo(savingsPageRoute);
            }),
          ),
        ],
      ),
    );
  }

  Widget fnButtons(String title, String subtitle, String icon, Color clr,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColorHelper().borderColor.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: clr.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  icon,
                ),
              ),
            ),
          ),
          height(8),
          appText(
            title,
            color: AppColorHelper().primaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  ListView _sortedTransactions() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.sortedTransactionsByDate.length,
        itemBuilder: (_, index) {
          final transList = controller.sortedTransactionsByDate[index];
          final colorHelper = AppColorHelper();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColorHelper().borderColor.withValues(alpha: 0.1)),
                color: colorHelper.cardColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        children: [
                          width(20),
                          appText(
                            DateHelper()
                                .formatTransactionDate(transList[0].date),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: colorHelper.primaryTextColor,
                          ),
                          width(10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColorHelper()
                                    .expenseColor
                                    .withValues(alpha: 0.2)),
                            child: appText(
                                calculateTotalAmount(transList).toString(),
                                fontSize: 10,
                                color: AppColorHelper()
                                    .expenseColor
                                    .withValues(alpha: 0.4),
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                    _transactionsList(transList, parentIndex: index),
                  ],
                ),
              ),
            ),
          );
        },
      );

  Padding _moneyDetails() {
    final colorHelper = AppColorHelper();
    final balance = controller.rxTotalbalance.value.toString();
    final digitsBeforeDecimal =
        balance.contains('.') ? balance.split('.')[0].length : balance.length;
    final fontSize = digitsBeforeDecimal < 7 ? 42.0 : 32.0;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorHelper.primaryColor.withValues(alpha: 0.25),
              colorHelper.cardColor.withValues(alpha: 0.15),
            ],
          ),
          border: Border.all(
            color: colorHelper.borderColor.withValues(alpha: 0.12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: colorHelper.primaryColor.withValues(alpha: 0.1),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(12),
            appText(
              "Cash Balance",
              fontSize: 13,
              color: colorHelper.primaryTextColor.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  "$rupeeEmoji $balance",
                  fontSize: fontSize,
                  color: colorHelper.primaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
                GestureDetector(
                  onTap: () async {
                    final amount = await IncomeBottomsheet.show(
                      Get.context!,
                      salaryBox: controller.salaryBox,
                      initialValue: controller.salary.value != 0.0
                          ? controller.salary.value
                          : 0,
                    );
                    if (amount != null) {
                      await controller.setSalary(amount);
                    }
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorHelper.primaryColor.withValues(alpha: 0.3),
                          colorHelper.primaryColorDark.withValues(alpha: 0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              colorHelper.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      controller.salary.value == 0.0 ? Icons.add : Icons.edit,
                      color: colorHelper.primaryTextColor,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            height(8),
            appText(
              "$rupeeEmoji ${controller.rxTotalspend.value}",
              color: colorHelper.primaryTextColor.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(
              width: Get.width * 0.95,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Obx(() {
                  final spend = controller.rxTotalspend.value;
                  final income = controller.salary.value;
                  final ratio =
                      (income > 0) ? (spend / income).clamp(0.0, 1.0) : 0.0;

                  return LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                    value: ratio,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor:
                        AlwaysStoppedAnimation(colorHelper.progressbarclr),
                    minHeight: 8.5,
                  );
                }),
              ),
            ),
            height(20),
            _balanceCard(),
          ],
        ),
      ),
    );
  }

  GestureDetector _balanceCard() {
    return GestureDetector(
      onTap: () {
        navigateTo(cahrtPageRoute);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        height: 70,
        decoration: BoxDecoration(
            color: AppColorHelper().primaryColorDark.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    AppColorHelper().primaryColorDark.withValues(alpha: 0.1))),
        child: Row(
          children: [
            // --- INCOME SIDE ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appText(
                    "Limit",
                    color: AppColorHelper()
                        .primaryTextColor
                        .withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  height(4),
                  Row(
                    children: [
                      appText(
                        controller.salary.toString(),
                        fontSize: 18,
                        color: AppColorHelper()
                            .primaryTextColor
                            .withValues(alpha: 0.5),
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- DIVIDER ---
            Container(
              height: 45,
              width: 3,
              color: AppColorHelper().textColor.withOpacity(0.2),
            ),

            // --- SPEND SIDE ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appText(
                    "Spend",
                    color: AppColorHelper().primaryTextColor.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  height(4),
                  appText(
                    "- ${controller.rxTotalspend.toString()}",
                    fontSize: 18,
                    color: AppColorHelper().primaryTextColor.withOpacity(0.5),
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _transactionsList(List<TransactionModel> transactions,
      {required int parentIndex}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return Obx(() {
          final isExpanded = controller.expandedIndexMap[parentIndex] == index;
          final Color baseColor = tx.type == 'Expense'
              ? AppColorHelper().expenseColor.withValues(alpha: 0.3)
              : AppColorHelper().incomeColor.withValues(alpha: 0.5);
          final cat = controller.categoryIcons.firstWhere(
            (c) => c['name'] == tx.category,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  final groupIndex = parentIndex;
                  if (controller.expandedIndexMap[groupIndex] == index) {
                    controller.expandedIndexMap.remove(groupIndex);
                  } else {
                    controller.expandedIndexMap[groupIndex] = index;
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColorHelper().cardColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          AppColorHelper().borderColor.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Main Tile Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon Box
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  cat['color'].withOpacity(0.1),
                                  cat['color'].withOpacity(0.3),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: cat['color'].withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: cat['color'].withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                cat['icon'],
                                color: AppColorHelper()
                                    .primaryTextColor
                                    .withValues(alpha: 0.5),
                                size: 22,
                              ),
                            ),
                          ),
                          width(12),

                          // Category + Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                appText(
                                  tx.category,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColorHelper().primaryTextColor,
                                ),
                                const SizedBox(height: 3),
                                appText(
                                  DateHelper.convertDateTimeToString(
                                      dateTime: tx.date),
                                  fontSize: 12,
                                  color: AppColorHelper()
                                      .primaryTextColor
                                      .withValues(alpha: 0.5),
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
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOutCubic,
                        child: isExpanded
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                      height: 16,
                                      thickness: 0.5,
                                      color: AppColorHelper()
                                          .borderColor
                                          .withOpacity(0.08),
                                    ),
                                    if (tx.description.isNotEmpty) ...[
                                      appText(
                                        "Description",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColorHelper()
                                            .primaryTextColor
                                            .withValues(alpha: 0.6),
                                      ),
                                      height(4),
                                      appText(
                                        tx.description,
                                        fontSize: 13,
                                        color: AppColorHelper()
                                            .primaryTextColor
                                            .withValues(alpha: 0.6),
                                      ),
                                      height(10),
                                    ],
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: errorGradientButtonContainer(
                                        height: 35,
                                        width: 100,
                                        color: AppColorHelper()
                                            .errorColor
                                            .withOpacity(0.1),
                                        onPressed: () {
                                          controller.deleteTransaction(tx.key);
                                          controller.expandedIndexMap.clear();
                                        },
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            appText(
                                              "Remove",
                                              fontSize: 11,
                                              color: AppColorHelper()
                                                  .primaryTextColor
                                                  .withValues(alpha: 0.7),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
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
