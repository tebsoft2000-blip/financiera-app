import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/app_exception.dart';
import '../../../core/base_controller.dart';
import '../../../core/endpoints.dart';
import '../../../core/messages.dart';
import '../../../data/models/role_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/app_repository.dart';
import '../states/users_state.dart';
import '../widgets/user_form.dart';

class UsersController extends BaseController {
  UsersController(this.auth, this._repository);

  final state = UsersState();
  final AuthController auth;
  final AppRepository _repository;
  final search = TextEditingController();
  final _offs = <void Function()>[];
  List<Role> roles = [];

  final email = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  bool _formOpen = false;

  bool get canAssign => auth.can('users.create') || auth.can('users.update');

  @override
  void onInit() {
    super.onInit();
    load();
    if (canAssign) loadRoles();
    _offs.add(_repository.onUsersChanged(load));
    _offs.add(
      _repository.onRolesChanged(() {
        if (canAssign) loadRoles();
      }),
    );
  }

  @override
  void onClose() {
    for (final off in _offs) {
      off();
    }
    for (final controller in [search, email, name, phone, address]) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> load() => run(() async {
    final result = await _repository.list(
      Endpoints.users,
      User.fromJson,
      query: {'page': state.page.value, 'pageSize': UsersState.pageSize, 'search': search.text.trim()},
    );
    if (isClosed) return;
    state.users.value = result.items;
    state.total.value = result.total;
  }, showError: false);

  Future<void> loadRoles() async {
    try {
      roles = (await _repository.list(Endpoints.assignableRoles, Role.fromJson)).items;
    } on AppException {
      roles = [];
    }
  }

  Future<void> reloadAll() => Future.wait([
    load(),
    if (canAssign) loadRoles(),
    auth.reload().catchError((_) {}, test: (e) => e is AppException),
  ]);

  void goTo(int value) {
    state.page.value = value;
    load();
  }

  Future<void> openForm(User? user) async {
    final formRoles = roles;
    email.text = user?.email ?? '';
    name.text = user?.name ?? '';
    phone.text = user?.phone ?? '';
    address.text = user?.address ?? '';
    state.roleId.value = user?.roleId ?? (formRoles.isEmpty ? null : formRoles.first.id);
    state.formError.value = '';
    state.formSaving.value = false;
    _formOpen = true;
    final saved = await showModalBottomSheet<bool>(
      context: Get.context!,
      isScrollControlled: true,
      builder: (_) => UserForm(
        user: user,
        roles: formRoles,
        canChangeRole:
            auth.can('users.update') && formRoles.isNotEmpty && user != null && user.id != auth.state.user.value?.id,
      ),
    );
    _formOpen = false;
    if (saved == true) load();
  }

  Future<void> save(User? user, bool canChangeRole) async {
    state.formSaving.value = true;
    state.formError.value = '';

    final profile = <String, dynamic>{
      'name': name.text.trim(),
      if (phone.text.trim().isNotEmpty) 'phone': phone.text.trim(),
      if (address.text.trim().isNotEmpty) 'address': address.text.trim(),
    };

    try {
      if (user != null) {
        await _repository.update(Endpoints.users, user.id, {
          ...profile,
          if (canChangeRole && state.roleId.value != user.roleId) 'roleId': state.roleId.value,
        }, User.fromJson);
      } else {
        await _repository.create(Endpoints.users, {
          ...profile,
          'email': email.text.trim(),
          'roleId': state.roleId.value,
        }, User.fromJson);
      }
      if (_formOpen) Get.back(result: true);
    } on AppException catch (e) {
      state.formError.value = e.message;
      state.formSaving.value = false;
    }
  }

  Future<void> _forceLogout(User user) async {
    final revokeDevices = false.obs;
    final ok = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text(Messages.usersForceLogout),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Messages.usersForceLogoutBody(user.name)),
            Obx(
              () => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(Messages.usersRevokeBiometric),
                value: revokeDevices.value,
                onChanged: (value) => revokeDevices.value = value,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text(Messages.commonCancel)),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text(Messages.usersForceLogout)),
        ],
      ),
    );
    if (ok == true) await run(() => _repository.forceLogout(user.id, revokeDevices.value), keepError: false);
  }

  void onAction(String action, User user) {
    switch (action) {
      case 'edit':
        openForm(user);
      case 'toggle':
        run(
          () => _repository.update(Endpoints.users, user.id, {'active': !user.active}, User.fromJson),
          keepError: false,
        );
      case 'logout':
        _forceLogout(user);
    }
  }
}
