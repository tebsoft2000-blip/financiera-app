import 'package:get/get.dart';

import '../data/models/user_model.dart';

class AuthState {
  final user = Rxn<User>();
  final permissions = <String>[].obs;
  final notice = ''.obs;
  final hasBiometric = false.obs;
  final ready = false.obs;
}
