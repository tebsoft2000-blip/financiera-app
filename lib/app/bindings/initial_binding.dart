import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../core/api_client.dart';
import '../core/realtime.dart';
import '../data/datasources/local_datasource.dart';
import '../data/datasources/remote_datasource.dart';
import '../data/repositories/app_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(), fenix: true);
    Get.lazyPut(() => Realtime(), fenix: true);
    Get.lazyPut(() => RemoteDataSource(Get.find(), Get.find()), fenix: true);
    Get.lazyPut(() => LocalDataSource(), fenix: true);
    Get.lazyPut(() => AppRepository(Get.find(), Get.find()), fenix: true);
    Get.put(AuthController(Get.find()), permanent: true);
  }
}
