part of 'verification_bloc.dart';

abstract class VerificationEvent {
  const VerificationEvent();

  List<Object> get props => [];
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
  List<Object> get props => [email, code, userType];
}

class ResendCodeEvent extends VerificationEvent {
  final String email;
  final String userType;

  const ResendCodeEvent({
    required this.email,
    required this.userType,
  });

  @override
  List<Object> get props => [email, userType];
}

class StartCountdownEvent extends VerificationEvent {
  const StartCountdownEvent();
}
