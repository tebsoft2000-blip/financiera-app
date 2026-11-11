import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/messages.dart';
import '../../../data/models/role_model.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/common_widgets.dart';
import '../controllers/users_controller.dart';

class UserForm extends GetView<UsersController> {
  const UserForm({super.key, this.user, required this.roles, required this.canChangeRole});

  final User? user;
  final List<Role> roles;
  final bool canChangeRole;

  @override
  Widget build(BuildContext context) {
    final isNew = user == null;
    final noRoles = isNew && roles.isEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Obx(() {
          final saving = controller.state.formSaving.value;
          final error = controller.state.formError.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(isNew ? Messages.usersNew : Messages.usersEdit, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              if (isNew) ...[
                TextField(
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(labelText: Messages.authEmail),
                ),
                const SizedBox(height: 12),
              ],
              TextField(controller: controller.name, decoration: const InputDecoration(labelText: Messages.usersFullName)),
              const SizedBox(height: 12),
              TextField(
                controller: controller.phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: Messages.usersPhone, hintText: Messages.usersPhoneHint),
              ),
              const SizedBox(height: 12),
              TextField(controller: controller.address, decoration: const InputDecoration(labelText: Messages.usersAddress)),
              if (noRoles) ...[
                const SizedBox(height: 12),
                const Message(Messages.usersNoRoles),
              ] else if (isNew || canChangeRole) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: controller.state.roleId.value,
                  decoration: const InputDecoration(labelText: Messages.usersRole),
                  items: [
                    if (user != null && !roles.any((role) => role.id == user!.roleId))
                      DropdownMenuItem(value: user!.roleId, child: Text(user!.roleName)),
                    for (final role in roles) DropdownMenuItem(value: role.id, child: Text(role.name)),
                  ],
                  onChanged: (value) => controller.state.roleId.value = value,
                ),
              ],
              if (isNew) ...[
                const SizedBox(height: 12),
                const Text(Messages.usersTemporaryPassword, style: TextStyle(color: AppColors.muted)),
              ],
              if (error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Message(error),
              ],
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: saving || noRoles ? null : () => controller.save(user, canChangeRole),
                child: Text(saving ? Messages.commonSaving : (isNew ? Messages.usersCreate : Messages.commonSaveChanges)),
              ),
            ],
          );
        }),
      ),
    );
  }
}
