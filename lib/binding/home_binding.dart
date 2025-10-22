import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../controller/home_controller.dart';
import '../service/home_service.dart';

class HomeBinding extends BaseBinding {
  const HomeBinding();

  @override
  void injectDependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    Get.lazyPut<HomeService>(() => HomeService(), fenix: true);
  }
}
