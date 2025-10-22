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
                      color: AppColorHelper().cardColor.withValues(alpha: 1.0),
                      borderRadius: BorderRadius.circular(25),
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
          child: appText(
            DateHelper().formatDateToWeekdayMonthDay(transactions[0].date),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColorHelper().primaryTextColor,
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
                ? AppColorHelper().expenseColor
                : AppColorHelper().incomeColor;
            final cat = controller.categoryIcons
                .firstWhere((c) => c['name'] == tx.category);
            bool isToday = DateHelper.convertDateTimeToString(
                    dateTime: tx.date) ==
                DateHelper.convertDateTimeToString(dateTime: DateTime.now());

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: AppColorHelper().cardColor.withOpacity(0.1),
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
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColorHelper().borderColor.withOpacity(0.05),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Main tile row
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: cat['color'].withOpacity(0.35),
                              ),
                              child: Icon(
                                cat['icon'],
                                color: AppColorHelper()
                                    .primaryTextColor
                                    .withOpacity(0.8),
                              ),
                            ),
                            width(12),
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
                                  appText(
                                    isToday
                                        ? 'Today'
                                        : DateHelper.convertDateTimeToString(
                                            dateTime: tx.date),
                                    fontSize: 13,
                                    color: AppColorHelper()
                                        .primaryTextColor
                                        .withOpacity(0.6),
                                  ),
                                ],
                              ),
                            ),
                            appText(
                              (tx.type == 'Expense' ? '- ₹ ' : '+ ₹ ') +
                                  tx.amount.toStringAsFixed(2),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: baseColor,
                            ),
                          ],
                        ),

                        // Expanded details
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: isExpanded
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                          color: AppColorHelper()
                                              .borderColor
                                              .withOpacity(0.05)),
                                      height(6),
                                      appText(
                                        'Description',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            AppColorHelper().primaryTextColor,
                                      ),
                                      height(4),
                                      appText(
                                        tx.description.isEmpty
                                            ? 'No description'
                                            : tx.description,
                                        color:
                                            AppColorHelper().primaryTextColor,
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

//   ListView _sortedTransactions() {
//     return ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: controller.sortedTransactionsByDate.length,
//         itemBuilder: (context, index) {
//           var transList = controller.sortedTransactionsByDate[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                   color: AppColorHelper().cardColor.withValues(alpha: 0.3),
//                   borderRadius: BorderRadius.circular(15)),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         width(20),
//                         appText(
//                             DateHelper()
//                                 .formatTransactionDate(transList[0].date),
//                             textAlign: TextAlign.start,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: AppColorHelper().primaryTextColor),
//                       ],
//                     ),
//                     _transactionsList(transList, parentIndex: index),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   ListView _transactionsList(List<TransactionModel> transactions,
//       {required int parentIndex}) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: transactions.length,
//       itemBuilder: (context, index) {
//         final tx = transactions[index];
//         return Obx(() {
//           final isExpanded = controller.expandedIndexMap[parentIndex] == index;
//           final Color baseColor = tx.type == 'Expense'
//               ? AppColorHelper().expenseColor
//               : AppColorHelper().incomeColor;
//           final cat = controller.categoryIcons.firstWhere(
//             (c) => c['name'] == tx.category,
//           );
//           bool isToday =
//               DateHelper.convertDateTimeToString(dateTime: tx.date) ==
//                   DateHelper.convertDateTimeToString(dateTime: DateTime.now());

//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 6),
//             child: Material(
//               borderRadius: BorderRadius.circular(16),
//               color: AppColorHelper().cardColor.withValues(alpha: 0.1),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(16),
//                 onTap: () {
//                   final groupIndex = parentIndex; // we'll pass this below
//                   if (controller.expandedIndexMap[groupIndex] == index) {
//                     controller.expandedIndexMap.remove(groupIndex);
//                   } else {
//                     controller.expandedIndexMap[groupIndex] = index;
//                   }
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                   decoration: BoxDecoration(
//                     border: isExpanded
//                         ? Border.all(
//                             color: AppColorHelper()
//                                 .borderColor
//                                 .withValues(alpha: 0.05))
//                         : Border.all(
//                             color: AppColorHelper()
//                                 .borderColor
//                                 .withValues(alpha: 0.05)),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       // Main Tile
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Gradient Circle Icon
//                           Container(
//                             width: 48,
//                             height: 48,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: cat['color'].withOpacity(0.35)),
//                             child: Icon(
//                               cat['icon'],
//                               color: AppColorHelper()
//                                   .primaryTextColor
//                                   .withValues(alpha: 0.8),
//                             ),
//                           ),
//                           width(12),
//                           // Title & Category
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 appText(
//                                   tx.category,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                   color: AppColorHelper().primaryTextColor,
//                                 ),
//                                 height(4),
//                                 isToday
//                                     ? appText(
//                                         "Today",
//                                         fontSize: 13,
//                                         color: AppColorHelper()
//                                             .primaryTextColor
//                                             .withOpacity(0.6),
//                                       )
//                                     : appText(
//                                         DateHelper.convertDateTimeToString(
//                                             dateTime: tx.date),
//                                         fontSize: 13,
//                                         color: AppColorHelper()
//                                             .primaryTextColor
//                                             .withOpacity(0.6),
//                                       ),
//                               ],
//                             ),
//                           ),
//                           // Amount
//                           appText(
//                             (tx.type == 'Expense' ? "- ₹ " : "+ ₹ ") +
//                                 tx.amount.toStringAsFixed(2),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: baseColor,
//                           ),
//                         ],
//                       ),

//                       // Expanded Details
//                       AnimatedSize(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                         child: isExpanded
//                             ? Padding(
//                                 padding: const EdgeInsets.only(top: 12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Divider(
//                                         color: AppColorHelper()
//                                             .borderColor
//                                             .withOpacity(0.05)),
//                                     height(6),
//                                     appText(
//                                       "Description",
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColorHelper().primaryTextColor,
//                                     ),
//                                     height(4),
//                                     appText(
//                                       tx.description.isEmpty
//                                           ? "No description"
//                                           : tx.description,
//                                       color: AppColorHelper().primaryTextColor,
//                                     ),
//                                     // height(10),
//                                     // Align(
//                                     //   alignment: Alignment.centerRight,
//                                     //   child: FilledButton.icon(
//                                     //     onPressed: () => controller
//                                     //         .deleteTransaction(tx.key),
//                                     //     icon: Icon(
//                                     //       Icons.close,
//                                     //       size: 20,
//                                     //       color: AppColorHelper().errorColor,
//                                     //     ),
//                                     //     label: appText("Remove",
//                                     //         color: AppColorHelper().errorColor,
//                                     //         fontWeight: FontWeight.w500),
//                                     //     style: FilledButton.styleFrom(
//                                     //       side: BorderSide(
//                                     //         color: AppColorHelper()
//                                     //             .errorColor
//                                     //             .withValues(alpha: 0.1),
//                                     //         width:
//                                     //             1.5, // optional: border width
//                                     //       ),
//                                     //       backgroundColor: AppColorHelper()
//                                     //           .errorColor
//                                     //           .withValues(alpha: 0.1),
//                                     //       padding: const EdgeInsets.symmetric(
//                                     //           vertical: 10, horizontal: 12),
//                                     //       shape: RoundedRectangleBorder(
//                                     //         borderRadius:
//                                     //             BorderRadius.circular(12),
//                                     //       ),
//                                     //     ),
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               )
//                             : const SizedBox.shrink(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//       },
//     );
//   }
// }
}
