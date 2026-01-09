import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_bloc.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_event.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_state.dart';
import 'package:petgo/features/auth/widgets/verification_code_input.dart';

class VerifyCodeStep extends StatelessWidget {
  final String userType;

  const VerifyCodeStep({super.key, required this.userType});

  void _resendCode(BuildContext context, String email) {
    context.read<PasswordResetBloc>().add(
      RequestResetCode(email: email, userType: userType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasswordResetBloc>().state;
    final email = state.email ?? '';

    final theme = Theme.of(context);

    return BlocListener<PasswordResetBloc, PasswordResetState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == PasswordResetStatus.error) {
          showAppSnackBar(
            context,
            state.errorMessage ?? 'Erro ao validar código',
            isError: true,
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  'assets/images/auth/reset_password.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Redefinir senha',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enviamos um código para:',
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5FBF),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Digite os 6 dígitos abaixo',
              style: TextStyle(fontSize: 14, color: Color(0xFF626C7C)),
            ),
            const SizedBox(height: 24),
            VerificationCodeInput(
              codeLength: 6,
              borderColor: const Color(0xFF8B5FBF),
              onChanged: (code) {
                if (code.length == 6) {
                  context.read<PasswordResetBloc>().add(
                    VerifyResetCode(code: code, userType: userType),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            if (state.canResend)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: state.status == PasswordResetStatus.loading
                      ? null
                      : () => _resendCode(context, email),
                  child: const Text('Reenviar código'),
                ),
              )
            else
              Text(
                'Reenviar em ${state.secondsRemaining}s',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
