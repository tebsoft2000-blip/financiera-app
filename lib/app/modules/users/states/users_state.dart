import 'package:get/get.dart';

import '../../../data/models/user_model.dart';

class UsersState {
  static const pageSize = 20;

  final users = Rxn<List<User>>();
  final total = 0.obs;
  final page = 1.obs;
  final roleId = RxnInt();
  final formError = ''.obs;
  final formSaving = false.obs;

  int get pages => total.value == 0 ? 1 : (total.value + pageSize - 1) ~/ pageSize;
}
