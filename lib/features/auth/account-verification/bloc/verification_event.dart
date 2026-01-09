import 'package:equatable/equatable.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object?> get props => [];
}

class VerifyCodeEvent extends VerificationEvent {
  final String email;
  final String code;
  final String userType;

  const VerifyCodeEvent({
    required this.email,
    required this.code,
    required this.userType,
  });

  @override
  List<Object?> get props => [email, code, userType];
}

class ResendCodeEvent extends VerificationEvent {
  final String email;
  final String userType;

  const ResendCodeEvent({required this.email, required this.userType});

  @override
  List<Object?> get props => [email, userType];
}

class StartCountdownEvent extends VerificationEvent {
  final int seconds;

  const StartCountdownEvent({this.seconds = 600});

  @override
  List<Object?> get props => [seconds];
}
