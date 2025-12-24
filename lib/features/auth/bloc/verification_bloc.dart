import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgo/features/auth/services/auth_service.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationInitial()) {
    // 🔹 Escuta correta do evento disparado pela tela
    on<VerifyCodeEvent>(_onVerifyCode);

    on<ResendCodeEvent>(_onResendCode);
    on<StartCountdownEvent>(_onStartCountdown);
  }

  Future<void> _onVerifyCode(
    VerifyCodeEvent event,
    Emitter<VerificationState> emit,
  ) async {
    print('🔹 _onVerifyCode: iniciando');
    emit(VerificationLoading());

    try {
      print('🔹 _onVerifyCode: chamando verifyCode com code=${event.code}');

      await AuthService.verifyCode(event.email, event.code, event.userType);

      print('✅ _onVerifyCode: sucesso! emitindo VerificationSuccess');
      emit(VerificationSuccess());
    } on ServerException catch (e) {
      print('🔴 _onVerifyCode: ServerException: ${e.message}');
      emit(VerificationError(e.message));
    } catch (e) {
      print('🔴 _onVerifyCode: catch genérico: $e');
      emit(VerificationError('Erro ao verificar código. Tente novamente.'));
    }
  }

  Future<void> _onResendCode(
    ResendCodeEvent event,
    Emitter<VerificationState> emit,
  ) async {
    print('📧 _onResendCode: iniciando');
    emit(ResendCodeLoading());

    try {
      print('📧 _onResendCode: chamando resendVerificationCode');

      await AuthService.resendVerificationCode(event.email, event.userType);

      print('✅ _onResendCode: sucesso! emitindo ResendCodeSuccess');
      emit(ResendCodeSuccess());

      add(const StartCountdownEvent());
    } on RateLimitException catch (e) {
      print('⏱️ _onResendCode: RateLimitException: ${e.message}');
      emit(ResendCodeRateLimit(e.message));
    } on ServerException catch (e) {
      print('🔴 _onResendCode: ServerException: ${e.message}');
      emit(ResendCodeError(e.message));
    } catch (e) {
      print('🔴 _onResendCode: Erro inesperado: $e');
      emit(ResendCodeError('Erro ao reenviar código. Tente novamente.'));
    }
  }

  Future<void> _onStartCountdown(
    StartCountdownEvent event,
    Emitter<VerificationState> emit,
  ) async {
    // ⏱️ Contagem regressiva (10 minutos)
    for (int i = 600; i > 0; i--) {
      emit(VerificationCountdown(i));
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
