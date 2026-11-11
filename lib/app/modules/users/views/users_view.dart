import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/messages.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/common_widgets.dart';
import '../controllers/users_controller.dart';
import '../widgets/user_card.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final users = controller.state.users.value;
      final total = controller.state.total.value;
      final page = controller.state.page.value;
      final error = controller.error.value;
      final pages = controller.state.pages;

      return Scaffold(
        floatingActionButton: controller.auth.can('users.create')
            ? FloatingActionButton.extended(
                onPressed: () => controller.openForm(null),
                icon: const Icon(Icons.person_add_alt),
                label: const Text(Messages.usersNew),
              )
            : null,
        body: RefreshIndicator(
          onRefresh: controller.reloadAll,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              TextField(
                controller: controller.search,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => controller.goTo(1),
                decoration: const InputDecoration(
                  hintText: Messages.usersSearchHint,
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                users == null ? Messages.usersLoading : Messages.usersTotal(total),
                style: const TextStyle(color: AppColors.muted),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Message(error),
              ],
              const SizedBox(height: 8),
              if (users != null && users.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(Messages.usersEmpty, textAlign: TextAlign.center),
                ),
              for (final user in users ?? <User>[]) UserCard(user),
              if (pages > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(onPressed: page > 1 ? () => controller.goTo(page - 1) : null, child: const Text(Messages.commonPrevious)),
                    Text(Messages.commonPageOf(page, pages)),
                    OutlinedButton(onPressed: page < pages ? () => controller.goTo(page + 1) : null, child: const Text(Messages.commonNext)),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}
