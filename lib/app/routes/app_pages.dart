import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../middlewares/auth_middleware.dart';
import '../middlewares/guest_middleware.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/roles/bindings/roles_binding.dart';
import '../modules/users/bindings/users_binding.dart';
import 'app_routes.dart';

abstract class AppPages {
  static const initial = Routes.splash;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      bindings: [UsersBinding(), RolesBinding()],
      middlewares: [AuthMiddleware()],
    ),
  ];
}
