import 'package:equatable/equatable.dart';

enum PasswordResetStatus {
  initial,
  loading,
  codeSent,
  codeVerified,
  passwordResetSuccess,
  error,
}

class PasswordResetState extends Equatable {
  final PasswordResetStatus status;
  final String? email;
  final String? resetToken;
  final String? errorMessage;
  final int secondsRemaining;
  final bool canResend;

  const PasswordResetState({
    this.status = PasswordResetStatus.initial,
    this.email,
    this.resetToken,
    this.errorMessage,
    this.secondsRemaining = 60,
    this.canResend = false,
  });

  PasswordResetState copyWith({
    PasswordResetStatus? status,
    String? email,
    String? resetToken,
    String? errorMessage,
    int? secondsRemaining,
    bool? canResend,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      email: email ?? this.email,
      resetToken: resetToken ?? this.resetToken,
      errorMessage: errorMessage,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      canResend: canResend ?? this.canResend,
    );
  }

  @override
  List<Object?> get props => [
    status,
    email,
    resetToken,
    errorMessage,
    secondsRemaining,
    canResend,
  ];
}
