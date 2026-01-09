import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/core/errors/app_exceptions.dart';
import 'package:petgo/features/auth/account-verification/bloc/verification_event.dart';
import 'package:petgo/features/auth/account-verification/bloc/verification_state.dart';
import 'package:petgo/features/auth/account-verification/email_verification_service.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(const VerificationInitial()) {
    on<VerifyCodeEvent>(_onVerifyCode);
    on<ResendCodeEvent>(_onResendCode);
  }

  Future<void> _onVerifyCode(
    VerifyCodeEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(const VerificationLoading());
    try {
      await EmailVerificationService.verifyEmailCode(
        email: event.email,
        code: event.code,
        userType: event.userType,
      );
      emit(const VerificationSuccess());
    } on ServerException catch (e) {
      emit(VerificationError(e.message));
    } on UnauthorizedException catch (e) {
      emit(VerificationError(e.message));
    } catch (_) {
      emit(const VerificationError('Erro ao verificar código. Tente novamente.'));
    }
  }

  Future<void> _onResendCode(
    ResendCodeEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(const ResendCodeLoading());
    try {
      await EmailVerificationService.resendVerificationCode(
        email: event.email,
        userType: event.userType,
      );
      emit(ResendCodeSuccess(cooldownSeconds: 60));
    } on RateLimitException catch (e) {
      emit(ResendCodeRateLimit(e.message));
    } on ServerException catch (e) {
      emit(ResendCodeError(e.message));
    } catch (_) {
      emit(const ResendCodeError('Erro ao reenviar código. Tente novamente.'));
    }
  }
}
