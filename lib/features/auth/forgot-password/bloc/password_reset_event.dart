import 'package:equatable/equatable.dart';

sealed class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object?> get props => [];
}

class RequestResetCode extends PasswordResetEvent {
  final String email;
  final String userType;

  const RequestResetCode({required this.email, required this.userType});

  @override
  List<Object?> get props => [email, userType];
}

class VerifyResetCode extends PasswordResetEvent {
  final String code;
  final String userType;

  const VerifyResetCode({required this.code, required this.userType});

  @override
  List<Object?> get props => [code, userType];
}

class SubmitNewPassword extends PasswordResetEvent {
  final String newPassword;
  final String confirmPassword;
  final String userType;

  const SubmitNewPassword({
    required this.newPassword,
    required this.confirmPassword,
    required this.userType,
  });

  @override
  List<Object?> get props => [newPassword, confirmPassword, userType];
}

class TickCountdown extends PasswordResetEvent {}

class RestartCountdown extends PasswordResetEvent {}
