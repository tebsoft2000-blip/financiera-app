import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/core/messages.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/common_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FinancieraApp());
}

class FinancieraApp extends StatelessWidget {
  const FinancieraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Messages.commonAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.brass,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.paper,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
      ),
      builder: (context, child) => Stack(
        children: [
          child!,
          const Positioned(top: 0, left: 0, right: 0, child: LoadingBar()),
        ],
      ),
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
