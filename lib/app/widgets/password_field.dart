import 'package:flutter/material.dart';

import '../core/messages.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.controller, required this.labelText, this.helperText, this.onSubmitted, this.prefixIcon});

  final TextEditingController controller;
  final String labelText;
  final String? helperText;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        helperText: widget.helperText,
        helperMaxLines: 2,
        suffixIcon: IconButton(
          tooltip: _obscure ? Messages.passwordShow : Messages.passwordHide,
          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}
