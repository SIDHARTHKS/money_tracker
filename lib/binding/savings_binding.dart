import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:tracker/controller/savings_controller.dart';

class SavingsBinding extends BaseBinding {
  const SavingsBinding();

  @override
  void injectDependencies() {
    Get.lazyPut<SavingsController>(() => SavingsController(), fenix: true);
  }
}
