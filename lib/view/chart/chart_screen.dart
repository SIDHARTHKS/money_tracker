import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/controller/transactions_controller.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/date_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/view/chart/pie_chart.dart';
import '../../helper/core/base/app_base_view.dart';
import '../widget/common_widget.dart';

class ChartScreen extends AppBaseView<TransactionsController> {
  const ChartScreen({super.key});

  @override
  Widget buildView() {
    final theme = Theme.of(Get.context!);

    return appScaffold(
      canpop: true,
      extendBodyBehindAppBar: false,
      bgcolor: AppColorHelper().backgroundColor,
      appBar: appBar(
        titleText: "Expense Breakdown",
        showbackArrow: true,
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Obx(() {
          return Column(
            children: [
              _monthSelector(theme),
              height(20),
              _chartCard(theme),
            ],
          );
        }),
      ),
    );
  }

  Widget _monthSelector(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColorHelper().cardColor3.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _monthArrow(Icons.arrow_back_ios_new_rounded, () {
              controller.changeMonth(false);
            }),
            appText(
              DateHelper().formatMonthYear(controller.selectedDate),
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            _monthArrow(Icons.arrow_forward_ios_rounded, () {
              controller.changeMonth(true);
            }),
          ],
        ),
      ),
    );
  }

  Widget _monthArrow(IconData icon, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColorHelper().cardColor.withOpacity(0.15),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 22, color: AppColorHelper().primaryTextColor),
      ),
    );
  }

  Widget _chartCard(ThemeData theme) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: CommonPieChart(
        data: controller.rxGraphData.value,
        total: controller.salary.value,
        showPercentages: false,
      ),
    );
  }
}
