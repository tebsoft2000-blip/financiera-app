import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = Get.find<AuthController>().state.user.value;
    if (user == null) return const RouteSettings(name: Routes.login);
    if (user.mustChangePassword && route != Routes.changePassword) {
      return const RouteSettings(name: Routes.changePassword);
    }
    return null;
  }
}
