import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/messages.dart';
import '../../../data/models/permissions.dart';
import '../../../data/models/role_model.dart';
import '../../../widgets/common_widgets.dart';
import '../controllers/roles_controller.dart';

class RoleForm extends GetView<RolesController> {
  const RoleForm({super.key, this.role});

  final Role? role;

  @override
  Widget build(BuildContext context) {
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
              Text(role == null ? Messages.rolesNew : Messages.rolesEdit, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(controller: controller.name, decoration: const InputDecoration(labelText: Messages.rolesName)),
              const SizedBox(height: 12),
              const Text(Messages.rolesPermissions, style: TextStyle(fontWeight: FontWeight.w600)),
              for (final entry in permissionLabels.entries) _permissionTile(entry.key, entry.value),
              const Text(Messages.rolesGrantHint, style: TextStyle(color: AppColors.muted)),
              if (error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Message(error),
              ],
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: saving ? null : () => controller.save(role),
                child: Text(saving ? Messages.commonSaving : (role == null ? Messages.rolesCreate : Messages.commonSaveChanges)),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _permissionTile(String permission, String label) {
    final requiredBy = controller.requiredBy(permission);
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      value: controller.state.selected.contains(permission),
      title: Text(label),
      subtitle: requiredBy.isEmpty ? null : Text(Messages.rolesRequiredBy(requiredBy)),
      onChanged: controller.auth.can(permission) && requiredBy.isEmpty ? (checked) => controller.toggle(permission, checked) : null,
    );
  }
}
