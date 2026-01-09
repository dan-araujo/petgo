import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_bloc.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_state.dart';
import 'package:petgo/features/auth/forgot-password/screens/request_email_step.dart';
import 'package:petgo/features/auth/forgot-password/screens/verify_code_step.dart';
import 'package:petgo/features/auth/forgot-password/screens/reset_password_step.dart';

class ForgotPasswordFlowPage extends StatefulWidget {
  final String userType;

  const ForgotPasswordFlowPage({
    super.key,
    required this.userType,
  });

  @override
  State<ForgotPasswordFlowPage> createState() =>
      _ForgotPasswordFlowPageState();
}

class _ForgotPasswordFlowPageState extends State<ForgotPasswordFlowPage> {
  final PageController _pageController = PageController();

  int _currentStep = 0;

  void _goToStep(int step) {
    _currentStep = step;
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onBackPressed() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordResetBloc(),
      child: BlocListener<PasswordResetBloc, PasswordResetState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == PasswordResetStatus.codeSent) {
            _goToStep(1);
          }

          if (state.status == PasswordResetStatus.codeVerified) {
            _goToStep(2);
          }

          if (state.status ==
              PasswordResetStatus.passwordResetSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) _onBackPressed();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Etapa ${_currentStep + 1} de 3'),
              leading: IconButton(
                onPressed: _onBackPressed,
                icon: const Icon(Icons.arrow_back),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 3,
                ),
              ),
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                RequestEmailStep(userType: widget.userType),
                VerifyCodeStep(userType: widget.userType),
                ResetPasswordStep(userType: widget.userType),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
