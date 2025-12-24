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
      // ✅ Use a mensagem da exceção (que vem do backend)
      emit(VerificationError(e.message));
    } catch (e) {
      print('🔴 _onVerifyCode: catch genérico: $e');
      // ✅ Mensagem genérica amigável
      emit(VerificationError('Erro ao verificar código. Tente novamente.'));
    }
  }

  Future<void> _onResendCode(
    ResendCodeEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(ResendCodeLoading());

    try {
      await AuthService.resendVerificationCode(event.email, event.userType);

      // ✅ Reenvio deu certo
      emit(ResendCodeSuccess());

      // 🔁 Reinicia o contador após reenviar
      add(const StartCountdownEvent());
    } on RateLimitException catch (e) {
      // ⏱️ Rate limit controlado pelo backend
      emit(ResendCodeRateLimit(e.message));
    } on ServerException catch (e) {
      print('🔴 _onVerifyCode: ServerException: ${e.message}');
      String errorMessage = e.message;
      if (e.message.contains('inválido')) {
        errorMessage = '❌ Código inválido. Verifique os dígitos.';
      }

      emit(VerificationError(errorMessage));
    } catch (e) {
      emit(ResendCodeError('Erro inesperado: $e'));
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
