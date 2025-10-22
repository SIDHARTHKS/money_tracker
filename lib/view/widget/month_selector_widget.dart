import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tracker/helper/color_helper.dart';
import '../../controller/home_controller.dart';

class MonthSelectorWidget extends StatefulWidget {
  final Function(DateTime selectedDate)?
      onMonthSelected; // updated to pass DateTime

  const MonthSelectorWidget({super.key, this.onMonthSelected});

  @override
  State<MonthSelectorWidget> createState() => _MonthSelectorWidgetState();
}

class _MonthSelectorWidgetState extends State<MonthSelectorWidget> {
  final HomeController homeController = Get.find<HomeController>();
  int selectedIndex = DateTime.now().month - 1;
  final int currentMonth = DateTime.now().month;
  final int year = 2025;
  final List<String> months = [];

  @override
  void initState() {
    super.initState();
    _generateMonths();
  }

  void _generateMonths() {
    // Generate months from Jan to current month for the given year
    for (int i = 1; i <= currentMonth; i++) {
      months.add(DateFormat('MMMM').format(DateTime(year, i)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: months.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => selectedIndex = index);

              // Create DateTime for the selected month
              final selectedDate = DateTime(year, index + 1);

              // ✅ Save in your HomeController
              homeController.updateMonth(selectedDate);

              // Optional: also call external callback
              widget.onMonthSelected?.call(selectedDate);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColorHelper().primaryColor.withOpacity(0.9)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                    : [],
              ),
              child: Center(
                child: Text(
                  months[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
