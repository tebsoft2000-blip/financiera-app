import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/app_theme.dart';
import '../controllers/login_controller.dart';
import 'login_button.dart';
import 'login_error_box.dart';
import 'login_texts.dart';

class OtpFields extends StatefulWidget {
  const OtpFields({super.key});

  @override
  State<OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  static const _length = 6;
  static const _validity = Duration(minutes: 5);

  final _controller = Get.find<LoginController>();
  final _focus = FocusNode();
  late final DateTime _expiresAt;
  Timer? _timer;
  Duration _remaining = _validity;

  bool get _expired => _remaining == Duration.zero;

  @override
  void initState() {
    super.initState();
    _expiresAt = DateTime.now().add(_validity);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focus.dispose();
    super.dispose();
  }

  void _tick() {
    final left = _expiresAt.difference(DateTime.now());
    setState(() => _remaining = left.isNegative ? Duration.zero : left);
    if (_expired) _timer?.cancel();
  }

  String get _countdown {
    final minutes = _remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool _canSubmit(String code) => code.length == _length && !_expired;

  void _submit() {
    if (_canSubmit(_controller.code.text) && !_controller.loading.value) _controller.submitCode();
  }

  @override
  Widget build(BuildContext context) {
    final timerColor = _expired ? AppColors.error : (_remaining.inSeconds <= 60 ? AppColors.accent : AppColors.muted);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          LoginTexts.otpTitle,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: '${LoginTexts.otpSentTo} ',
            children: [
              TextSpan(
                text: LoginTexts.maskEmail(_controller.email.text.trim()),
                style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          style: const TextStyle(fontSize: 14, color: AppColors.muted, height: 1.4),
        ),
        const SizedBox(height: 22),
        _codeBoxes(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_outlined, size: 18, color: timerColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                _expired ? LoginTexts.otpExpired : '${LoginTexts.otpExpiresIn} $_countdown',
                textAlign: TextAlign.center,
                style: TextStyle(color: timerColor, fontWeight: FontWeight.w600, fontFeatures: const [FontFeature.tabularFigures()]),
              ),
            ),
          ],
        ),
        const LoginErrorBox(),
        const SizedBox(height: 22),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller.code,
          builder: (context, value, _) => LoginButton(
            label: LoginTexts.verify,
            enabled: _canSubmit(value.text),
            onPressed: _controller.submitCode,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            onPressed: _controller.restart,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text(LoginTexts.back, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _codeBoxes() {
    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          ListenableBuilder(
            listenable: Listenable.merge([_controller.code, _focus]),
            builder: (context, _) {
              final code = _controller.code.text;
              final active = code.length.clamp(0, _length - 1);
              return Row(
                children: List.generate(_length, (index) {
                  final filled = index < code.length;
                  final focused = _focus.hasFocus && index == active;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: filled ? AppColors.primary.withValues(alpha: 0.06) : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: focused ? AppColors.primary : (filled ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border),
                          width: focused ? 2 : 1.2,
                        ),
                      ),
                      child: Text(
                        filled ? code[index] : '',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          Positioned.fill(
            child: TextField(
              controller: _controller.code,
              focusNode: _focus,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: _length,
              showCursor: false,
              enableInteractiveSelection: false,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: Colors.transparent, fontSize: 1),
              decoration: const InputDecoration(
                counterText: '',
                filled: false,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onTap: () => _controller.code.selection = TextSelection.collapsed(offset: _controller.code.text.length),
              onSubmitted: (_) => _submit(),
            ),
          ),
        ],
      ),
    );
  }
}
