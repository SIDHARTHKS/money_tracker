import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/gen/assets.gen.dart';
import 'package:tracker/helper/app_string.dart';
import 'package:tracker/helper/navigation.dart';
import 'package:tracker/helper/route.dart';
import 'package:tracker/model/transaction_model.dart';
import 'package:tracker/view/home/income_bottomsheet.dart';
import 'package:tracker/view/home/transaction_bottomsheet.dart';
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
      customAppBar("Hi, ${controller.rxUserName} !", "sidhuks29@gmail.com");

  Widget _buildBody() {
    final colorHelper = AppColorHelper();

    return Obx(() => appContainer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _moneyDetails(),
                if (controller.rxTotalincome.value > 0) _incomeContainer(),
                _transactionAndLedger(),
                height(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (controller.salary.value != 0.0)
                      _quickAddButton(colorHelper),
                    if (controller.transactions.isNotEmpty) _showAllButton(),
                  ],
                ),
                _sortedTransactions(),
              ],
            ),
          ),
        ));
  }

  Widget _quickAddButton(AppColorHelper colorHelper) => GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Container(
            height: 30,
            width: 125,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorHelper.primaryColor.withValues(alpha: 0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appText("Quick add",
                    fontWeight: FontWeight.w600,
                    color: colorHelper.primaryColorDark),
                width(5),
                Icon(Icons.add, size: 20, color: colorHelper.primaryColorDark),
              ],
            ),
          ),
        ),
      );

  GestureDetector _showAllButton() => GestureDetector(
        onTap: () => navigateTo(viewAllPageRoute),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 30,
                width: 95,
                decoration: BoxDecoration(
                  color: AppColorHelper().primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorHelper()
                          .primaryColorDark
                          .withValues(alpha: 0.010),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    width(2),
                    appText("Show All",
                        color: AppColorHelper().primaryColorDark,
                        fontWeight: FontWeight.w500),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: AppColorHelper().primaryColorDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Padding _incomeContainer() {
    final colorHelper = AppColorHelper();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: Get.width,
        height: 50,
        decoration: BoxDecoration(
          color: colorHelper.primaryColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            appText("Additional Income : ",
                fontSize: 15,
                color: colorHelper.textColor,
                fontWeight: FontWeight.w600),
            appText(" + ${controller.rxTotalincome}",
                fontSize: 15,
                color: colorHelper.textColor,
                fontWeight: FontWeight.w800),
          ],
        ),
      ),
    );
  }

  Container _transactionAndLedger() {
    final colorHelper = AppColorHelper();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 120,
      child: Row(
        children: [
          if (controller.salary.value != 0.0)
            Flexible(
              child: fnButtons(
                  "Transaction",
                  "New Transaction",
                  Assets.icons.transaction.path,
                  colorHelper.transactionColor, () async {
                await showModalBottomSheet(
                  context: Get.context!,
                  isScrollControlled: true,
                  backgroundColor: colorHelper.cardColor,
                  constraints: BoxConstraints.expand(height: Get.height * 0.88),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  builder: (_) => const TransactionBottomsheet(),
                );
              }),
            ),
          if (controller.salary.value != 0.0) width(10),
          Flexible(
            child: fnButtons("Ledger", "View Ledger",
                Assets.icons.arrowRight.path, colorHelper.ledgerColor, () {
              navigateTo(ledgerPageRoute);
            }),
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
    final fontSize = digitsBeforeDecimal < 7 ? 52.0 : 40.0;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: Get.width,
        height: 265,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorHelper.primaryColorDark.withValues(alpha: 0.5),
              colorHelper.primaryColorDark.withValues(alpha: 0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(15),
            appText("Your Balance",
                fontSize: 16,
                color: colorHelper.textColor,
                fontWeight: FontWeight.w500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  "$rupeeEmoji $balance",
                  fontSize: fontSize,
                  color: colorHelper.textColor,
                  fontWeight: FontWeight.w600,
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorHelper.cardColor.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.salary.value == 0.0 ? Icons.add : Icons.edit,
                      color: colorHelper.primaryColorDark,
                    ),
                  ),
                ),
              ],
            ),
            height(5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                appText(
                    "${controller.rxTotalspend.value}/${controller.salary.value}",
                    color: colorHelper.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                SizedBox(
                  width: Get.width * 0.95,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Obx(() {
                      final spend = controller.rxTotalspend.value;
                      final income = controller.salary.value;
                      final ratio =
                          (income > 0) ? (spend / income).clamp(0.0, 1.0) : 0.0;

                      return LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10),
                        value: ratio,
                        backgroundColor:
                            const Color.fromARGB(84, 255, 255, 255),
                        valueColor:
                            AlwaysStoppedAnimation(colorHelper.progressbarclr),
                        minHeight: 8.5,
                      );
                    }),
                  ),
                ),
                height(15),
                _balanceCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded fnButtons(String title, String subtitle, String icon, Color clr,
      VoidCallback onTap) {
    final colorHelper = AppColorHelper();

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 130,
          width: Get.width * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: clr,
            border: Border.all(
                color: colorHelper.primaryColor.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appText(title,
                  color: colorHelper.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
              height(18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: colorHelper.cardColor.withValues(alpha: 0.3),
                  border: Border.all(
                      color: colorHelper.primaryColor.withValues(alpha: 0.05)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(subtitle,
                        color: colorHelper.textColor,
                        fontSize: controller.salary.value != 0.0 ? 11 : 16,
                        fontWeight: FontWeight.w700),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colorHelper.boxShadowColor
                                .withValues(alpha: 0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                            spreadRadius: 1,
                          ),
                        ],
                        color: colorHelper.cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(icon),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        height: 75,
        decoration: BoxDecoration(
            color: AppColorHelper().primaryColorDark.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color:
                    AppColorHelper().primaryColorDark.withValues(alpha: 0.2))),
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
                    color: AppColorHelper().textColor.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  height(4),
                  Row(
                    children: [
                      appText(
                        controller.salary.toString(),
                        fontSize: 20,
                        color: AppColorHelper().textColor,
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
                    color: AppColorHelper().textColor.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  height(4),
                  appText(
                    "- ${controller.rxTotalspend.toString()}",
                    fontSize: 20,
                    color: AppColorHelper().textColor,
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
              ? AppColorHelper().expenseColor
              : AppColorHelper().incomeColor;
          final cat = controller.categoryIcons.firstWhere(
            (c) => c['name'] == tx.category,
          );
          bool isToday =
              DateHelper.convertDateTimeToString(dateTime: tx.date) ==
                  DateHelper.convertDateTimeToString(dateTime: DateTime.now());

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
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
                                color: cat['color'].withOpacity(0.35)),
                            child: Icon(
                              cat['icon'],
                              color: AppColorHelper()
                                  .primaryTextColor
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                          width(12),
                          // Title & Category
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
                                height(4),
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
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FilledButton.icon(
                                        onPressed: () => controller
                                            .deleteTransaction(tx.key),
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
