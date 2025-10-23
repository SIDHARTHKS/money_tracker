import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:tracker/controller/landing_controller.dart';

class LandingBinding extends BaseBinding {
  const LandingBinding();

  @override
  void injectDependencies() {
    Get.lazyPut<LandingController>(() => LandingController(), fenix: true);
  }
}
