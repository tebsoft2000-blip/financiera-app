import 'package:get/get.dart';

import '../../../data/models/role_model.dart';

class RolesState {
  final roles = Rxn<List<Role>>();
  final selected = <String>{}.obs;
  final formError = ''.obs;
  final formSaving = false.obs;
}
