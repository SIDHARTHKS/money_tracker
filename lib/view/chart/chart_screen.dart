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
      padding: const EdgeInsets.only(top: 16.0),
      child: Obx(() {
        return Column(
          children: [
            _monthSelectorCard(),
            height(20),
            controller.rxGraphData.value.isEmpty ? _emptyState() : _chartCard(),
          ],
        );
      }),
    );
  }

  /// Modern month selector with shadow and elevation
  Widget _monthSelectorCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColorHelper().cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            )
          ],
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
          color: AppColorHelper().primaryColor.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 22, color: AppColorHelper().primaryColor),
      ),
    );
  }

  /// Empty state with Lottie animation and text
  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          height(120),
          Lottie.asset(
            'assets/lottie/nodata.json',
            fit: BoxFit.contain,
            repeat: true,
            height: 350,
            width: 350,
          ),
          height(20),
          appText(
            "No Data Available",
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColorHelper().primaryTextColor.withOpacity(0.5),
          ),
          height(10),
          appText(
            "Track your expenses to see a detailed breakdown here.",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColorHelper().primaryTextColor.withOpacity(0.35),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Chart card with modern elevation and shadow
  Widget _chartCard() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 0),
            blurRadius: 100,
          ),
        ],
        color: AppColorHelper().cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CommonPieChart(
            data: controller.rxGraphData.value,
            total: controller.salary.value,
            showPercentages: false,
          ),
          height(12),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: AppColorHelper().primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          height(30),
        ],
      ),
    );
  }
}
