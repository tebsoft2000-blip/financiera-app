import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import 'login_texts.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key, required this.height, required this.overlap});

  final double height;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          Positioned(top: -60, right: -40, child: _circle(180)),
          Positioned(bottom: -30, left: -50, child: _circle(140)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, overlap + 12),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 16, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: const Icon(Icons.account_balance, color: AppColors.primary, size: 32),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        LoginTexts.appName,
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        LoginTexts.greeting(DateTime.now()),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)),
    );
  }
}
