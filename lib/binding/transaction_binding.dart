import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:tracker/controller/transactions_controller.dart';

class TransactionBinding extends BaseBinding {
  const TransactionBinding();

  @override
  void injectDependencies() {
    Get.lazyPut<TransactionsController>(() => TransactionsController(),
        fenix: true);
  }
}
