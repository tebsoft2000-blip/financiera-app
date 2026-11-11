import 'package:get/get.dart';

import '../widgets/common_widgets.dart';
import 'app_exception.dart';

abstract class BaseController extends GetxController {
  final loading = false.obs;
  final error = RxnString();

  Future<T?> run<T>(
    Future<T> Function() action, {
    String? successMessage,
    bool showError = true,
    bool keepError = true,
  }) async {
    loading.value = true;
    if (keepError) error.value = null;
    try {
      final result = await action();
      if (successMessage != null) showSnackbar(successMessage);
      return result;
    } on AppException catch (e) {
      if (keepError) error.value = e.message;
      if (showError) showSnackbar(e.message);
      return null;
    } finally {
      loading.value = false;
    }
  }
}
