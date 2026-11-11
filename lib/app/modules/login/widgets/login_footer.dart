import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import 'login_texts.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 14, color: AppColors.muted),
            SizedBox(width: 6),
            Text(
              LoginTexts.secureConnection,
              style: TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'Versión ${LoginTexts.appVersion}',
          style: TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    );
  }
}
