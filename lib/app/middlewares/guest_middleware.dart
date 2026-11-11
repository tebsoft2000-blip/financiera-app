import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) =>
      Get.find<AuthController>().state.user.value == null ? null : const RouteSettings(name: Routes.home);
}
