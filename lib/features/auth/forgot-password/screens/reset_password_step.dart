import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/primary_button.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_bloc.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_event.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_state.dart';

class ResetPasswordStep extends StatefulWidget {
  final String userType;

  const ResetPasswordStep({super.key, required this.userType});

  @override
  State<ResetPasswordStep> createState() => _ResetPasswordStepState();
}

class _ResetPasswordStepState extends State<ResetPasswordStep> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get _isStrongPassword {
    final password = _passwordController.text;
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<PasswordResetBloc>().add(
      SubmitNewPassword(
        newPassword: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        userType: widget.userType,
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state.status == PasswordResetStatus.passwordResetSuccess) {
          showAppSnackBar(context, 'Senha redefinida com sucesso');
          Navigator.of(context).pop();
        }

        if (state.status == PasswordResetStatus.error) {
          showAppSnackBar(
            context,
            state.errorMessage ?? 'Erro ao redefinir senha',
            isError: true,
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nova senha',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (_) => setState(() {}),
                validator: validatePassword,
                decoration: InputDecoration(
                  labelText: 'Nova senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _passwordController.text.isEmpty ? 0 : _isStrongPassword ? 1 : 0.5,
                minHeight: 4,
                color: _isStrongPassword ? Colors.green : Colors.orange,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<PasswordResetBloc, PasswordResetState>(
                builder: (context, state) {
                  return PrimaryButton(
                    isLoading: state.status == PasswordResetStatus.loading,
                    label: 'Salvar nova senha',
                    onPressed: _submit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
