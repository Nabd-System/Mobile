import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/ai_chat/data/models/chat_message_model.dart';
import 'package:nabd/features/ai_chat/domain/repositories/ai_chat_repository.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final AiChatRepository repository;

  AiChatBloc({required this.repository}) : super(const AiChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final userMessage = ChatMessageModel.user(event.message);

    // أضف رسالة المستخدم
    emit(
      state.copyWith(
        messages: [...state.messages, userMessage],
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final reply = await repository.sendMessage(event.message);
      final aiMessage = ChatMessageModel.ai(reply);

      // أضف رد الـ AI
      emit(
        state.copyWith(
          messages: [...state.messages, aiMessage],
          isLoading: false,
        ),
      );
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to get response. Please try again.',
        ),
      );
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<AiChatState> emit) {
    emit(const AiChatState());
  }
}
