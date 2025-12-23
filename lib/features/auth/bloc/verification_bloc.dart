import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/features/auth/services/auth_service.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationInitial()) {
    on<VerifyCodeEvent>(_onVerifyCode);
    on<ResendCodeEvent>(_onResendCode);
    on<StartCountdownEvent>(_onStartCountdown);
  }

  Future<void> _onVerifyCode(
    VerifyCodeEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(VerificationLoading());
    try {
      final result = await AuthService.verifyCode(event.email, event.code);
      if (result['success']) {
        emit(VerificationSuccess());
      } else {
        emit(
          VerificationError(result['message'] ?? 'Erro ao verificar código'),
        );
      }
    } on ServerException catch (e) {
      emit(VerificationError(e.message));
    } catch (e) {
      emit(VerificationError('Erro inesperado: $e'));
    }
  }

  Future<void> _onResendCode(
    ResendCodeEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(ResendCodeLoading());
    try {
      final result = await AuthService.resendVerificationCode(event.email);
      if (result['success']) {
        emit(ResendCodeSuccess());
        add(StartCountdownEvent());
      } else {
        emit(ResendCodeError(result['message'] ?? 'Erro ao reenviar código'));
      }
    } on RateLimitException catch (e) {
      emit(ResendCodeRateLimit(e.message));
    } on ServerException catch (e) {
      emit(ResendCodeError(e.message));
    } catch (e) {
      emit(ResendCodeError('Erro inesperado: $e'));
    }
  }

  Future<void> _onStartCountdown(
    StartCountdownEvent event,
    Emitter<VerificationState> emit,
  ) async {
    for (int i = 600; i > 0; i--) {
      emit(VerificationCountdown(i));
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
