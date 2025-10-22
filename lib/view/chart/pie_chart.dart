import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/view/widget/common_widget.dart';

class CommonPieChart extends StatelessWidget {
  final Map<String, double> data;
  final double total;
  final double radius;
  final double centerSpaceRadius;
  final TextStyle? labelStyle;
  final bool showPercentages;

  CommonPieChart({
    super.key,
    required this.data,
    required this.total,
    this.radius = 100,
    this.centerSpaceRadius = 70,
    this.labelStyle,
    this.showPercentages = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spent = data.values.fold(0.0, (a, b) => a + b);
    final unspent = (total - spent).clamp(0.0, total);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColorHelper().cardColor.withOpacity(0.95),
            AppColorHelper().cardColor.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 0),
            blurRadius: 100,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            appText(
              "Spending Overview",
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppColorHelper().primaryTextColor,
            ),
            height(45),
            _buildPieChart(theme, spent, unspent),
            height(35),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(ThemeData theme, double spent, double unspent) {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: _generateSections(spent, unspent, theme),
              centerSpaceRadius: centerSpaceRadius,
              sectionsSpace: 3,
              startDegreeOffset: -45,
              borderData: FlBorderData(show: false),
            ),
            swapAnimationDuration: const Duration(milliseconds: 900),
            swapAnimationCurve: Curves.easeOutQuint,
          ),

          // Glassy center circle
          Container(
            width: centerSpaceRadius * 2,
            height: centerSpaceRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorHelper().cardColor.withOpacity(0.7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
              // backdropFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            ),
          ),

          // Center Percentage Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: appText(
                  getPercentage(spent, total),
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color:
                      AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
                ),
              ),
              height(4),
              appText(
                "Used",
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColorHelper().primaryTextColor.withValues(alpha: 0.6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final sortedEntries =
        (data.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

    return Column(
      children: sortedEntries.map((entry) {
        final category = entry.key;
        final amount = entry.value;
        final color = _getColorForCategory(category);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.00),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildBadge(category),
              ),
              width(10),
              Expanded(
                child: appText(
                  category,
                  fontWeight: FontWeight.w600,
                  color: AppColorHelper().primaryTextColor,
                ),
              ),
              appText(
                "${amount.toStringAsFixed(0)} ₹",
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColorHelper().primaryTextColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<PieChartSectionData> _generateSections(
      double spent, double unspent, ThemeData theme) {
    final List<PieChartSectionData> sections = [];

    if (data.isNotEmpty && spent > 0) {
      for (var entry in data.entries) {
        final category = entry.key;
        final amount = entry.value;
        final color = _getColorForCategory(category);

        sections.add(
          PieChartSectionData(
            value: amount,
            color: color.withValues(alpha: 0.65),
            title: showPercentages
                ? "${((amount / total) * 100).toStringAsFixed(1)}%"
                : "",
            radius: radius,
            titleStyle: labelStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
            badgeWidget: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.45),
              ),
              padding: const EdgeInsets.all(4),
              child: _buildBadge(category),
            ),
            badgePositionPercentageOffset: 1.25,
          ),
        );
      }
    }

    if (unspent > 0) {
      sections.add(
        PieChartSectionData(
          value: unspent,
          color: AppColorHelper().borderColor.withOpacity(0.1),
          title: "",
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          radius: radius - 10,
        ),
      );
    }

    return sections;
  }

  String getPercentage(double spent, double total) {
    if (total == 0) return "0%";
    final percentage = (spent / total) * 100;
    final rounded = percentage.roundToDouble();
    return "${rounded.toInt()}%";
  }

  Icon _buildBadge(String category, {double size = 20}) {
    final matchedCategory = categoryIcons.firstWhere(
      (item) => item['name'].toString().toLowerCase() == category.toLowerCase(),
      orElse: () => {'icon': Icons.circle_outlined, 'color': Colors.grey},
    );
    return Icon(matchedCategory['icon'], color: Colors.black, size: size);
  }

  Color _getColorForCategory(String category) {
    final matchedCategory = categoryIcons.firstWhere(
      (item) => item['name'].toString().toLowerCase() == category.toLowerCase(),
      orElse: () => {'color': Colors.grey},
    );
    return matchedCategory['color'] as Color;
  }

  final List<Map<String, dynamic>> categoryIcons = [
    {
      'name': 'Food',
      'icon': Icons.fastfood_outlined,
      'color': AppColorHelper().foodColor
    },
    {
      'name': 'Salary',
      'icon': Icons.attach_money_rounded,
      'color': AppColorHelper().salaryColor
    },
    {
      'name': 'Fuel',
      'icon': Icons.local_gas_station_outlined,
      'color': AppColorHelper().fuelColor
    },
    {
      'name': 'Travel',
      'icon': Icons.flight_takeoff_outlined,
      'color': AppColorHelper().travelColor
    },
    {
      'name': 'Home Rent',
      'icon': Icons.home_outlined,
      'color': AppColorHelper().homeRentColor
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag_outlined,
      'color': AppColorHelper().shoppingColor
    },
    {
      'name': 'Movies',
      'icon': Icons.movie_outlined,
      'color': AppColorHelper().moviesColor
    },
    {
      'name': 'Bills',
      'icon': Icons.receipt_long_outlined,
      'color': AppColorHelper().billsColor
    },
    {
      'name': 'Recharge',
      'icon': Icons.phone_android_outlined,
      'color': AppColorHelper().rechargeColor
    },
    {
      'name': 'Savings',
      'icon': Icons.account_balance_wallet_outlined,
      'color': AppColorHelper().savingsColor
    },
    {
      'name': 'Miscellaneous',
      'icon': Icons.star,
      'color': AppColorHelper().missColor,
    },
  ];
}
