import 'dart:io';
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
    on<AnalyzeMedicineEvent>(_onAnalyzeMedicine);
    on<AnalyzeSkinEvent>(_onAnalyzeSkin);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final userMessage = ChatMessageModel.user(event.message);
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      clearError: true,
    ));

    try {
      final reply = await repository.sendMessage(event.message);
      emit(state.copyWith(
        messages: [...state.messages, ChatMessageModel.ai(reply)],
        isLoading: false,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to get response. Please try again.',
      ));
    }
  }

  Future<void> _onAnalyzeMedicine(
    AnalyzeMedicineEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final userMessage = ChatMessageModel.user('💊 Medicine image sent for analysis');
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      clearError: true,
    ));

    try {
      final result = await repository.analyzeMedicine(event.imageFile);
      emit(state.copyWith(
        messages: [...state.messages, ChatMessageModel.medicineAnalysis(result)],
        isLoading: false,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to analyze image. Please try again.',
      ));
    }
  }

  Future<void> _onAnalyzeSkin(
    AnalyzeSkinEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final userMessage = ChatMessageModel.user('🔬 Skin image sent for analysis');
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      clearError: true,
    ));

    try {
      final result = await repository.analyzeSkin(event.imageFile);
      emit(state.copyWith(
        messages: [
          ...state.messages,
          ChatMessageModel.skinAnalysis(result),
        ],
        isLoading: false,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to analyze skin image. Please try again.',
      ));
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<AiChatState> emit) {
    emit(const AiChatState());
  }
}