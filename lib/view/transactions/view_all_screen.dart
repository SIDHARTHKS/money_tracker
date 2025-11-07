import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tracker/controller/transactions_controller.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/date_helper.dart';
import '../../model/transaction_model.dart';
import '../widget/common_widget.dart';

class ViewAllScreen extends AppBaseView<TransactionsController> {
  const ViewAllScreen({super.key});

  @override
  Widget buildView() {
    final theme = Theme.of(Get.context!);
    return appScaffold(
      canpop: true,
      extendBodyBehindAppBar: false,
      appBar: appBar(
        titleText: "Transactions",
        showbackArrow: true,
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, bottom: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.sortedTransactionsByMonthMap.length,
              itemBuilder: (context, monthIndex) {
                final monthKey = controller.sortedTransactionsByMonthMap.keys
                    .elementAt(monthIndex);
                final monthDays =
                    controller.sortedTransactionsByMonthMap[monthKey]!;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColorHelper()
                              .borderColor
                              .withValues(alpha: 0.1)),
                      color: AppColorHelper().cardColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month Header
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: appText(
                            DateFormat('MMMM yy').format(DateFormat('MM/yyyy')
                                .parse(monthKey)), // e.g., October 2025
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColorHelper().primaryTextColor,
                          ),
                        ),

                        // Loop through days in month
                        ...monthDays.asMap().entries.map((dayEntry) {
                          final dayIndex = dayEntry.key;
                          final transactionsList = dayEntry.value;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child:
                                _dailyTransactions(transactionsList, dayIndex),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ));
  }

  Widget _dailyTransactions(
      List<TransactionModel> transactions, int parentIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Row(
            children: [
              appText(
                DateHelper().formatDateToWeekdayMonthDay(transactions[0].date),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColorHelper().primaryTextColor,
              ),
              width(10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColorHelper().expenseColor.withValues(alpha: 0.2),
                ),
                child: appText(
                  calculateTotalAmount(transactions).toString(),
                  fontSize: 10,
                  color: AppColorHelper().expenseColor.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        ),

        // Transactions for that day
        ...transactions.asMap().entries.map((txEntry) {
          final txIndex = txEntry.key;
          final tx = txEntry.value;

          return Obx(() {
            final isExpanded =
                controller.expandedIndexMap[parentIndex] == txIndex;
            final Color baseColor = tx.type == 'Expense'
                ? AppColorHelper().expenseColor.withValues(alpha: 0.3)
                : AppColorHelper().incomeColor.withValues(alpha: 0.5);
            final cat = controller.categoryIcons
                .firstWhere((c) => c['name'] == tx.category);
            bool isToday = DateHelper.convertDateTimeToString(
                    dateTime: tx.date) ==
                DateHelper.convertDateTimeToString(dateTime: DateTime.now());

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (controller.expandedIndexMap[parentIndex] == txIndex) {
                      controller.expandedIndexMap.remove(parentIndex);
                    } else {
                      controller.expandedIndexMap[parentIndex] = txIndex;
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColorHelper().cardColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColorHelper()
                            .borderColor
                            .withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Main tile row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon container with gradient + shadow
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
                                    isToday
                                        ? 'Today'
                                        : DateHelper.convertDateTimeToString(
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

                        // Expanded details
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOutCubic,
                          child: isExpanded
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        height: 16,
                                        thickness: 0.5,
                                        color: AppColorHelper()
                                            .borderColor
                                            .withValues(alpha: 0.06),
                                      ),
                                      height(6),
                                      appText(
                                        'Description',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppColorHelper()
                                            .primaryTextColor
                                            .withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(height: 4),
                                      appText(
                                        tx.description.isEmpty
                                            ? 'No description'
                                            : tx.description,
                                        fontSize: 13,
                                        color: AppColorHelper()
                                            .primaryTextColor
                                            .withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: buttonContainer(
                                          height: 35,
                                          width: 100,
                                          color: AppColorHelper()
                                              .cardColor
                                              .withOpacity(0.1),
                                          borderColor: AppColorHelper()
                                              .errorBorderColor
                                              .withValues(alpha: 0.6),
                                          onPressed: () {
                                            controller
                                                .deleteTransaction(tx.key);
                                            controller.expandedIndexMap.clear();
                                          },
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              appText(
                                                "Remove",
                                                fontSize: 11,
                                                color: AppColorHelper()
                                                    .errorColor
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
        }).toList(),
      ],
    );
  }
}
