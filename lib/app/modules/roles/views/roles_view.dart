import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/messages.dart';
import '../../../data/models/role_model.dart';
import '../../../widgets/common_widgets.dart';
import '../controllers/roles_controller.dart';
import '../widgets/role_card.dart';

class RolesView extends GetView<RolesController> {
  const RolesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roles = controller.state.roles.value;
      final error = controller.error.value;

      return Scaffold(
        floatingActionButton: controller.auth.can('roles.create')
            ? FloatingActionButton.extended(
                onPressed: () => controller.openForm(null),
                icon: const Icon(Icons.add),
                label: const Text(Messages.rolesNew),
              )
            : null,
        body: RefreshIndicator(
          onRefresh: controller.reloadAll,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              Text(
                roles == null ? Messages.rolesLoading : Messages.rolesDescription,
                style: const TextStyle(color: AppColors.muted),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Message(error),
              ],
              const SizedBox(height: 8),
              for (final role in roles ?? <Role>[]) RoleCard(role),
            ],
          ),
        ),
      );
    });
  }
}
