import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/messages.dart';
import '../../../widgets/common_widgets.dart';
import '../../roles/controllers/roles_controller.dart';
import '../../roles/views/roles_view.dart';
import '../../users/controllers/users_controller.dart';
import '../../users/views/users_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final auth = controller.auth;
      final user = auth.state.user.value;
      if (user == null) return const SizedBox.shrink();
      final sections = [
        if (auth.can('users.read'))
          (
            label: Messages.usersTitle,
            icon: Icons.people_outline,
            page: GetBuilder<UsersController>(builder: (_) => const UsersView()),
          ),
        if (auth.can('roles.read'))
          (
            label: Messages.rolesTitle,
            icon: Icons.shield_outlined,
            page: GetBuilder<RolesController>(builder: (_) => const RolesView()),
          ),
      ];
      final index = controller.state.index.value < sections.length ? controller.state.index.value : 0;

      return Listener(
        onPointerDown: (_) => auth.touch(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text(user.roleName, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
              ],
            ),
            actions: [
              if (auth.state.hasBiometric.value)
                PopupMenuButton<void>(
                  itemBuilder: (context) => [
                    PopupMenuItem(onTap: auth.disableBiometric, child: const Text(Messages.biometricDisable)),
                  ],
                ),
              IconButton(tooltip: Messages.authLogout, icon: const Icon(Icons.logout), onPressed: auth.logout),
            ],
          ),
          body: sections.isEmpty
              ? RefreshIndicator(
                  onRefresh: controller.retry,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(32),
                    children: [
                      const Text(Messages.rolesNoSections, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Center(
                        child: OutlinedButton(
                          onPressed: controller.retry,
                          child: const Text(Messages.commonRetry),
                        ),
                      ),
                    ],
                  ),
                )
              : sections[index].page,
          bottomNavigationBar: sections.length < 2
              ? null
              : NavigationBar(
                  selectedIndex: index,
                  onDestinationSelected: (value) => controller.state.index.value = value,
                  destinations: [
                    for (final section in sections) NavigationDestination(icon: Icon(section.icon), label: section.label),
                  ],
                ),
        ),
      );
    });
  }
}
