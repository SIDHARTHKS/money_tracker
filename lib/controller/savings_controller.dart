import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import 'package:tracker/helper/core/base/app_base_controller.dart';
import 'package:tracker/model/savings_model.dart';

class SavingsController extends AppBaseController {
  // savings
  late Box<SavingsModel> _savingsBox;
  RxList<SavingsModel> savingsList = <SavingsModel>[].obs;
  RxDouble totalSavings = 0.0.obs;

  // expande
  var expandedIndex = (-1).obs;

  //////////////////////////////////////////////////////
  Future<void> loadAllSavings() async {
    final all = _savingsBox.values.toList();
    all.sort((a, b) => b.date.compareTo(a.date));
    savingsList.assignAll(all);
    calculateTotal();
  }

  void calculateTotal() {
    totalSavings.value =
        savingsList.fold(0.0, (sum, item) => sum + item.amount);
  }

  Future<void> addSavings(double amount, String? note) async {
    final newItem = SavingsModel(
      amount: amount,
      date: DateTime.now(),
      note: note,
    );

    await _savingsBox.add(newItem);
    await loadAllSavings();
  }

  Future<void> deleteSavings(dynamic key) async {
    // Directly delete by key
    await _savingsBox.delete(key);
    await loadAllSavings();
  }
  /////////////////////////////////////////////////////

  @override
  Future<void> onInit() async {
    super.onInit();

    // Open boxes first
    _savingsBox = Hive.box<SavingsModel>('savingsBox');

    // Load initial data
    await loadAllSavings();

    // Watch for changes
    _savingsBox.watch().listen((event) => loadAllSavings());
  }
}
