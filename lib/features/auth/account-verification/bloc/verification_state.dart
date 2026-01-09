import 'package:equatable/equatable.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => [];
}

class VerificationInitial extends VerificationState {
  const VerificationInitial();
}

class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

class VerificationSuccess extends VerificationState {
  const VerificationSuccess();
}

class VerificationError extends VerificationState {
  final String message;

  const VerificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class VerificationCountdown extends VerificationState {
  final int seconds;

  const VerificationCountdown(this.seconds);

  @override
  List<Object?> get props => [seconds];
}

class ResendCodeLoading extends VerificationState {
  const ResendCodeLoading();
}

class ResendCodeSuccess extends VerificationState {
  final int cooldownSeconds;

  const ResendCodeSuccess({this.cooldownSeconds = 600});

  @override
  List<Object?> get props => [cooldownSeconds];
}

class ResendCodeError extends VerificationState {
  final String message;

  const ResendCodeError(this.message);

  @override
  List<Object?> get props => [message];
}

class ResendCodeRateLimit extends VerificationState {
  final String message;

  const ResendCodeRateLimit(this.message);

  @override
  List<Object?> get props => [message];
}
