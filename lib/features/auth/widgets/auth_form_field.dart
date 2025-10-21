import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final bool obscure;
  final String? Function(String?)? validator;
  final bool isOptional;

  const AuthFormField({
    super.key,
    required this.controller,
    required this.label,
    this.inputType = TextInputType.text,
    this.obscure = false,
    this.validator,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: isOptional ? '$label (opcional)' : label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (isOptional && (value == null || value.isEmpty)) return null;

          if (validator != null) return validator!(value);

          if (value == null || value.isEmpty) {
            return 'O campo "$label" é obrigatório';
          }

          return null;
        },
      ),
    );
  }
}
