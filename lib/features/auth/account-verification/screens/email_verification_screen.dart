import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/features/auth/account-verification/bloc/verification_bloc.dart';
import 'package:petgo/features/auth/account-verification/bloc/verification_event.dart';
import 'package:petgo/features/auth/account-verification/bloc/verification_state.dart';
import 'package:petgo/features/auth/widgets/verification_code_input.dart';
import 'package:petgo/routes/auth_routes.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String userType;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.userType,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _codeInputKey = GlobalKey<State<VerificationCodeInput>>();
  String _verificationCode = '';

  Timer? _countdownTimer;
  int _secondsLeft = 0;

  void _startCountdown(int seconds) {
    _countdownTimer?.cancel();
    setState(() => _secondsLeft = seconds);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        setState(() {});
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF208B8D)),
        ),
      ),
      body: BlocListener<VerificationBloc, VerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email verificado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            final loginRoute = AuthRoutes.getLoginRoute(widget.userType);
            Navigator.of(context).pushReplacementNamed(loginRoute);
          } else if (state is VerificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: const Color(0xFFEF4444),
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          } else if (state is ResendCodeRateLimit) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFE57373),
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is ResendCodeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Novo código enviado para seu email!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            _startCountdown(state.cooldownSeconds);
          } else if (state is ResendCodeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/auth/verification_lock.png',
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 32),
              const Text(
                'Confirmação de Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Enviamos um código para: ',
                style: TextStyle(fontSize: 14, color: Colors.green[600]),
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF208B8D),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Digite os 6 dígitos abaixo',
                style: TextStyle(fontSize: 14, color: Color(0xFF626C7C)),
              ),
              const SizedBox(height: 24),
              VerificationCodeInput(
                key: _codeInputKey,
                onChanged: (code) => setState(() => _verificationCode = code),
              ),
              const SizedBox(height: 32),
              BlocBuilder<VerificationBloc, VerificationState>(
                builder: (context, state) {
                  final isLoading = state is VerificationLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading || _verificationCode.length != 6
                          ? null
                          : () {
                              context.read<VerificationBloc>().add(
                                VerifyCodeEvent(
                                  email: widget.email,
                                  code: _verificationCode,
                                  userType: widget.userType,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF208B8D),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Não recebeu o código?',
                    style: TextStyle(fontSize: 14, color: Color(0xFF626C7C)),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<VerificationBloc, VerificationState>(
                    builder: (context, state) {
                      final isLoading = state is ResendCodeLoading;
                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                                context.read<VerificationBloc>().add(
                                  ResendCodeEvent(
                                    email: widget.email,
                                    userType: widget.userType,
                                  ),
                                );
                              },
                        child: Text(
                          'Enviar novamente',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isLoading
                                ? Colors.grey
                                : const Color(0xFF208B8D),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_secondsLeft > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '⏱️ Expira em: ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF626C7C)),
                    ),
                    Text(
                      '${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
