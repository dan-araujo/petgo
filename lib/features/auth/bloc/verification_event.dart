part of 'verification_bloc.dart';

abstract class VerificationEvent {}

class VerifyCodeEvent extends VerificationEvent {
  final String email;
  final String code;

  VerifyCodeEvent({required this.email, required this.code});
}

class ResendCodeEvent extends VerificationEvent {
  final String email;
  ResendCodeEvent({required this.email});
}

class StartCountdownEvent extends VerificationEvent {}
