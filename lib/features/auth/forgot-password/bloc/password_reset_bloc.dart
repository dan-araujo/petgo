import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_event.dart';
import 'package:petgo/features/auth/forgot-password/bloc/password_reset_state.dart';
import 'package:petgo/features/auth/forgot-password/password_reset_service.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  Timer? _timer;

  PasswordResetBloc() : super(const PasswordResetState()) {
    on<RequestResetCode>(_onRequestResetCode);
    on<VerifyResetCode>(_onVerifyResetCode);
    on<SubmitNewPassword>(_onSubmitNewPassword);
    on<TickCountdown>(_onTickCountdown);
    on<RestartCountdown>(_onRestartCountdown);
  }

  Future<void> _onRequestResetCode(
    RequestResetCode event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(state.copyWith(status: PasswordResetStatus.loading));

    try {
      await PasswordResetService.requestResetCode(
        email: event.email,
        userType: event.userType,
      );
      emit(
        state.copyWith(
          status: PasswordResetStatus.codeSent,
          email: event.email,
          secondsRemaining: 60,
          canResend: false,
        ),
      );
      _startTimer();
    } catch (e) {
      emit(
        state.copyWith(
          status: PasswordResetStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onVerifyResetCode(
    VerifyResetCode event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(state.copyWith(status: PasswordResetStatus.loading));

    try {
      final resetToken = await PasswordResetService.verifyResetCode(
        email: state.email!,
        code: event.code,
        userType: event.userType,
      );
      emit(
        state.copyWith(
          status: PasswordResetStatus.codeVerified,
          resetToken: resetToken,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PasswordResetStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSubmitNewPassword(
    SubmitNewPassword event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(state.copyWith(status: PasswordResetStatus.loading));

    try {
      await PasswordResetService.resetPassword(
        resetToken: state.resetToken!,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
        userType: event.userType,
      );
      emit(state.copyWith(status: PasswordResetStatus.passwordResetSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          status: PasswordResetStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onTickCountdown(
    TickCountdown event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (state.secondsRemaining <= 1) {
      _timer?.cancel();
      emit(state.copyWith(secondsRemaining: 0, canResend: true));
    } else {
      emit(state.copyWith(secondsRemaining: state.secondsRemaining - 1));
    }
  }

  void _onRestartCountdown(
    RestartCountdown event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(state.copyWith(secondsRemaining: 60, canResend: false));
    _startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TickCountdown());
    });
  }
}
