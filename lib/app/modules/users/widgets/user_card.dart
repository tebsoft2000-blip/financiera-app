import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/messages.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/common_widgets.dart';
import '../controllers/users_controller.dart';

class UserCard extends GetView<UsersController> {
  const UserCard(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final auth = controller.auth;
      final isMe = user.id == auth.state.user.value?.id;
      final actions = <PopupMenuEntry<String>>[
        if (user.canManage && auth.can('users.update')) const PopupMenuItem(value: 'edit', child: Text(Messages.commonEdit)),
        if (user.canManage && auth.can('users.disable') && !isMe)
          PopupMenuItem(value: 'toggle', child: Text(user.active ? Messages.commonDeactivate : Messages.commonActivate)),
        if (user.canManage && auth.can('sessions.revoke') && !isMe)
          const PopupMenuItem(value: 'logout', child: Text(Messages.usersForceLogout)),
      ];

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          isThreeLine: true,
          title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.email),
              Text(
                Messages.usersDetails(user.roleName, user.active, user.phone),
                style: TextStyle(color: user.active ? AppColors.muted : AppColors.danger),
              ),
            ],
          ),
          trailing: actions.isEmpty
              ? null
              : PopupMenuButton<String>(
                  itemBuilder: (_) => actions,
                  onSelected: (action) => controller.onAction(action, user),
                ),
        ),
      );
    });
  }
}
