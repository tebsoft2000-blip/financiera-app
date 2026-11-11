import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/messages.dart';
import '../../../data/models/permissions.dart';
import '../../../data/models/role_model.dart';
import '../../../widgets/common_widgets.dart';
import '../controllers/roles_controller.dart';

class RoleCard extends GetView<RolesController> {
  const RoleCard(this.role, {super.key});

  final Role role;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final canEdit = controller.auth.can('roles.update') && !role.isSystem;
      final canDelete = controller.auth.can('roles.delete') && !role.isSystem;

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(role.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
                  if (role.isSystem)
                    const Text(Messages.rolesProtected, style: TextStyle(color: AppColors.brass, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              for (final entry in permissionLabels.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        role.permissions.contains(entry.key) ? Icons.check : Icons.remove,
                        size: 18,
                        color: role.permissions.contains(entry.key) ? AppColors.primary : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.value,
                        style: TextStyle(color: role.permissions.contains(entry.key) ? null : Colors.grey),
                      ),
                    ],
                  ),
                ),
              if (canEdit || canDelete)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (canEdit) TextButton(onPressed: () => controller.openForm(role), child: const Text(Messages.commonEdit)),
                    if (canDelete)
                      TextButton(
                        onPressed: () => controller.remove(role),
                        style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                        child: const Text(Messages.commonDelete),
                      ),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}
