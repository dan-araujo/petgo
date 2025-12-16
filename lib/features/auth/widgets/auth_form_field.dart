import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final bool obscure;
  final String? Function(String?)? validator;
  final bool isOptional;
  final Color? focusedBorderColor;

  const AuthFormField({
    super.key,
    required this.controller,
    required this.label,
    this.inputType = TextInputType.text,
    this.obscure = false,
    this.validator,
    this.isOptional = false,
    this.focusedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = focusedBorderColor ?? const Color(0xFF1F2121);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscure,
        style: const TextStyle(color: Color(0xFF1F2121), fontSize: 14),
        decoration: InputDecoration(
          labelText: isOptional ? '$label (opcional)' : label,
          labelStyle: const TextStyle(
            color: Color(0xFF1F2121),
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
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
