import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/controller/transactions_controller.dart';
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
      appBar: appBar(
        titleText: "Expense Breakdown",
        showbackArrow: true,
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Obx(() => SizedBox(
                // width: 500,
                height: 1000, // fixed height
                child: CommonPieChart(
                  data: controller.rxGraphData.value,
                  total: 10000,
                  showPercentages: false,
                ),
              )),
          // Other widgets...
        ],
      ),
    );
  }
}
