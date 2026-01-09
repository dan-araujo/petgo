import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/core/utils/snackbar_helper.dart';
import 'package:petgo/core/utils/validators.dart';
import 'package:petgo/core/widgets/primary_button.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_bloc.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_event.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_state.dart';

class RequestEmailStep extends StatefulWidget {
  final String userType;

  const RequestEmailStep({super.key, required this.userType});

  @override
  State<RequestEmailStep> createState() => _RequestEmailStepState();
}

class _RequestEmailStepState extends State<RequestEmailStep> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _requestResetCode() {
    if (!_formKey.currentState!.validate()) return;
    context.read<PasswordResetBloc>().add(
      RequestResetCode(
        email: _emailController.text.trim(),
        userType: widget.userType,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordResetBloc, PasswordResetState>(
      listenWhen: (previousState, currentState) =>
          previousState.status != currentState.status &&
          (currentState.status == PasswordResetStatus.codeSent ||
              currentState.status == PasswordResetStatus.error),
      listener: (context, state) {
        if (state.status == PasswordResetStatus.codeSent) {
          showAppSnackBar(
            context,
            'Caso o e-mail exista, um código será enviado',
          );
        }
        if (state.status == PasswordResetStatus.error) {
          showAppSnackBar(
            context,
            state.errorMessage ?? 'Erro ao enviar código',
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
              SizedBox(
                height: 200,
                child: Center(
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 100,
                    semanticLabel: 'Ícone de recuperação de senha',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Esqueceu sua senha?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('Digite o seu e-mail para receber o código'),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 32),
              BlocBuilder<PasswordResetBloc, PasswordResetState>(
                builder: (context, state) {
                  final isLoading = state.status == PasswordResetStatus.loading;

                  return PrimaryButton(
                    isLoading: isLoading,
                    label: 'Enviar código',
                    onPressed: isLoading ? null : _requestResetCode,
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
