import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/view/widget/common_widget.dart';

class CommonPieChart extends StatelessWidget {
  final Map<String, double> data; // e.g. {'Food': 2000, 'Travel': 1500}
  final double total; // e.g. salary = 10000
  final double radius;
  final double centerSpaceRadius;
  final TextStyle? labelStyle;
  final bool showPercentages;

  const CommonPieChart({
    super.key,
    required this.data,
    required this.total,
    this.radius = 90,
    this.centerSpaceRadius = 80,
    this.labelStyle,
    this.showPercentages = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spent = data.values.fold(0.0, (a, b) => a + b);
    final unspent = (total - spent).clamp(0.0, total);

    return Material(
      elevation: 0,
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pie chart area with fixed height
            SizedBox(
              width: radius * 2 + 32,
              height: 400,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shadow layer for 3D effect
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        center: Alignment.center,
                        radius: 0.8,
                      ),
                    ),
                  ),

                  // Pie chart
                  PieChart(
                    PieChartData(
                      sections: _generateSections(spent, unspent, theme),
                      centerSpaceRadius: centerSpaceRadius,
                      sectionsSpace: 2,
                      startDegreeOffset: -100,
                      borderData: FlBorderData(show: false),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 800),
                    swapAnimationCurve: Curves.easeInOutCubic,
                  ),

                  // Elevated center
                  Container(
                    width: centerSpaceRadius * 2,
                    height: centerSpaceRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Colors.white, Colors.grey.shade200],
                        center: Alignment.topLeft,
                        radius: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 6),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),

                  // Center text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Spent",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        "₹${spent.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "/ ₹${total.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Legend
            Column(
              children: data.entries.map((entry) {
                final category = entry.key;
                final amount = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColorHelper().cardColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _getColorForCategory(category)
                                .withValues(alpha: 0.45),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        width(8),
                        Expanded(
                          child: appText(
                            category,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColorHelper().primaryTextColor,
                          ),
                        ),
                        appText(
                          " ${amount.toStringAsFixed(0)}",
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColorHelper()
                              .primaryTextColor
                              .withValues(alpha: 0.7),
                        ),
                        width(8),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections(
      double spent, double unspent, ThemeData theme) {
    final List<PieChartSectionData> sections = [];

    if (data.isNotEmpty && spent > 0) {
      for (var entry in data.entries) {
        final category = entry.key;
        final amount = entry.value;
        final percentage = (amount / total * 100).clamp(0, 100);

        sections.add(
          PieChartSectionData(
            value: amount,
            title: showPercentages ? "${percentage.toStringAsFixed(1)}%" : "",
            radius: radius,
            color: _getColorForCategory(category).withValues(alpha: 0.45),
            titleStyle: labelStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
            badgeWidget: _buildBadge(category),
            badgePositionPercentageOffset: 1.3,
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.1),
              width: 1.5,
            ),
          ),
        );
      }
    }

    if (unspent > 0) {
      final unspentPercent = (unspent / total * 100).clamp(0, 100);
      sections.add(
        PieChartSectionData(
          value: unspent,
          title: showPercentages ? "${unspentPercent.toStringAsFixed(1)}%" : "",
          radius: radius - 4,
          color: _getColorForCategory('unspent'),
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1.5,
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildBadge(String category) {
    IconData icon;
    switch (category.toLowerCase()) {
      case 'food':
        icon = Icons.restaurant_outlined;
        break;
      case 'travel':
        icon = Icons.flight_takeoff_outlined;
        break;
      case 'fuel':
        icon = Icons.local_gas_station_outlined;
        break;
      case 'shopping':
        icon = Icons.shopping_bag_outlined;
        break;
      case 'movies':
        icon = Icons.movie_outlined;
        break;
      case 'bills':
        icon = Icons.receipt_long_outlined;
        break;
      default:
        icon = Icons.circle_outlined;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Icon(icon, size: 14, color: Colors.grey[800]),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return AppColorHelper().foodColor;
      case 'salary':
        return AppColorHelper().salaryColor;
      case 'fuel':
        return AppColorHelper().fuelColor;
      case 'travel':
        return AppColorHelper().travelColor;
      case 'home rent':
        return AppColorHelper().homeRentColor;
      case 'shopping':
        return AppColorHelper().shoppingColor;
      case 'movies':
        return AppColorHelper().moviesColor;
      case 'bills':
        return AppColorHelper().billsColor;
      case 'recharge':
        return AppColorHelper().rechargeColor;
      case 'savings':
        return AppColorHelper().savingsColor;
      case 'unspent':
        return const Color.fromARGB(255, 147, 147, 147).withOpacity(0.6);
      default:
        return AppColorHelper().billsColor;
    }
  }
}
