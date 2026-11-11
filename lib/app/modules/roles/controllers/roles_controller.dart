import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/app_exception.dart';
import '../../../core/base_controller.dart';
import '../../../core/endpoints.dart';
import '../../../core/messages.dart';
import '../../../data/models/permissions.dart';
import '../../../data/models/role_model.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../widgets/common_widgets.dart';
import '../states/roles_state.dart';
import '../widgets/role_form.dart';

class RolesController extends BaseController {
  RolesController(this.auth, this._repository);

  final state = RolesState();
  final AuthController auth;
  final AppRepository _repository;
  void Function()? _off;

  final name = TextEditingController();
  bool _formOpen = false;

  @override
  void onInit() {
    super.onInit();
    load();
    _off = _repository.onRolesChanged(load);
  }

  @override
  void onClose() {
    _off?.call();
    name.dispose();
    super.onClose();
  }

  Future<void> load() => run(() async {
    final result = (await _repository.list(Endpoints.roles, Role.fromJson)).items;
    if (!isClosed) state.roles.value = result;
  }, showError: false);

  Future<void> reloadAll() => Future.wait([load(), auth.reload().catchError((_) {}, test: (e) => e is AppException)]);

  Future<void> openForm(Role? role) async {
    name.text = role?.name ?? '';
    state.selected
      ..clear()
      ..addAll(role?.permissions ?? const []);
    state.formError.value = '';
    state.formSaving.value = false;
    _formOpen = true;
    final saved = await showModalBottomSheet<bool>(
      context: Get.context!,
      isScrollControlled: true,
      builder: (_) => RoleForm(role: role),
    );
    _formOpen = false;
    if (saved == true) load();
  }

  Future<void> remove(Role role) async {
    if (!await confirm(Messages.rolesDelete, Messages.rolesConfirmDelete(role.name))) return;
    await run(() => _repository.remove(Endpoints.roles, role.id), keepError: false);
  }

  void toggle(String permission, bool? checked) {
    if (checked == true) {
      state.selected.add(permission);
      state.selected.addAll(permissionDependencies[permission] ?? const []);
    } else {
      state.selected.remove(permission);
    }
  }

  List<String> requiredBy(String permission) => [
    for (final item in state.selected)
      if (permissionDependencies[item]?.contains(permission) ?? false) permissionLabels[item] ?? item,
  ];

  Future<void> save(Role? role) async {
    state.formSaving.value = true;
    state.formError.value = '';

    final body = {'name': name.text.trim(), 'permissions': state.selected.toList()};

    try {
      if (role != null) {
        await _repository.update(Endpoints.roles, role.id, body, Role.fromJson);
      } else {
        await _repository.create(Endpoints.roles, body, Role.fromJson);
      }
      if (_formOpen) Get.back(result: true);
    } on AppException catch (e) {
      state.formError.value = e.message;
      state.formSaving.value = false;
    }
  }
}
