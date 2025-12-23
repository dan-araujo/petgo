part of 'verification_bloc.dart';

abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationError extends VerificationState {
  final String message;
  VerificationError(this.message);
}

class VerificationCountdown extends VerificationState {
  final int seconds;
  VerificationCountdown(this.seconds);
}

class ResendCodeLoading extends VerificationState {}

class ResendCodeSuccess extends VerificationState {}

class ResendCodeError extends VerificationState {
  final String message;
  ResendCodeError(this.message);
}

class ResendCodeRateLimit extends VerificationState {
  final String message;
  ResendCodeRateLimit(this.message);
}
