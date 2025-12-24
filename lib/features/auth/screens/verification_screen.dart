import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/features/auth/bloc/verification_bloc.dart';
import 'package:petgo/features/auth/widgets/verification_code_input.dart';
import 'package:petgo/routes/auth_routes.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String userType;

  const VerificationScreen({
    super.key,
    required this.email,
    required this.userType,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeInputKey = GlobalKey<State<VerificationCodeInput>>();
  String _verificationCode = '';

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
          // ✅ APENAS navega se VerificationSuccess
          if (state is VerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email verificado com sucesso!')),
            );
            final loginRoute = AuthRoutes.getLoginRoute(widget.userType);
            Navigator.of(context).pushReplacementNamed(loginRoute);
          }
          // ✅ APENAS mostra erro se VerificationError
          else if (state is VerificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          // ✅ Rate limit de resend
          else if (state is ResendCodeRateLimit) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          // ✅ Sucesso ao reenviar
          else if (state is ResendCodeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Novo código enviado!')),
            );
          }
          // ✅ Erro ao reenviar
          else if (state is ResendCodeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/verification_lock.png',
                  height: 120, width: 120),
              const SizedBox(height: 32),
              const Text(
                '🔐 Confirmação de Email',
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
              BlocBuilder<VerificationBloc, VerificationState>(
                builder: (context, state) {
                  return VerificationCodeInput(
                    key: _codeInputKey,
                    onChanged: (code) => {
                      setState(() => _verificationCode = code),
                    },
                  );
                },
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
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
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
              BlocBuilder<VerificationBloc, VerificationState>(
                builder: (context, state) {
                  if (state is VerificationCountdown) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '⏱️ Expira em: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF626C7C),
                          ),
                        ),
                        Text(
                          '${state.seconds}s',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

