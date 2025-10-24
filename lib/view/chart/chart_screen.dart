import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
    return appScaffold(
      canpop: true,
      extendBodyBehindAppBar: false,
      bgcolor: AppColorHelper().backgroundColor,
      appBar: appBar(
        titleText: "Expense Breakdown",
        showbackArrow: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Obx(() {
          return Column(
            children: [
              _monthSelector(),
              height(20),
              controller.rxGraphData.value.isEmpty
                  ? Column(
                      children: [
                        height(150),
                        Lottie.asset(
                          'assets/lottie/nodata.json',
                          fit: BoxFit.contain,
                          repeat: true,
                          height: 400,
                          width: 400,
                        ),
                        appText("No Data Available",
                            color: AppColorHelper()
                                .primaryTextColor
                                .withValues(alpha: 0.5),
                            fontWeight: FontWeight.w700,
                            fontSize: 24)
                      ],
                    )
                  : _chartCard(),
            ],
          );
        }),
      ),
    );
  }

  Widget _monthSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
              color: AppColorHelper().borderColor.withValues(alpha: 0.1)),
          color: AppColorHelper().cardColor,
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
              color: AppColorHelper().primaryTextColor,
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

  Widget _chartCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: CommonPieChart(
        data: controller.rxGraphData.value,
        total: controller.salary.value,
        showPercentages: false,
      ),
    );
  }
}
