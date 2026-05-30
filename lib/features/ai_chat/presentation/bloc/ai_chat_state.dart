part of 'ai_chat_bloc.dart';

class AiChatState {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final String? errorMessage;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AiChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
