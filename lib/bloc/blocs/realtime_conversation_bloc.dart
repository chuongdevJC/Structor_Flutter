import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/data/entities/conversation.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/conversation_repository.dart';

class RealtimeConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  RealtimeConversationBloc(ConversationState initialState)
      : super(initialState);

  final _conversationRepository = getIt<ConversationRepository>();

  @override
  Stream<ConversationState> mapEventToState(ConversationEvent event) async* {
    if (event is InitConversation) {
      yield* _mapInitialConversationToState(event.conversationID);
    }
  }

  Stream<ConversationState> _mapInitialConversationToState(
    String conversationID,
  ) async* {
    try {
      final _conversations = _conversationRepository.getConversations(conversationID);
      await for (Conversation data in _conversations) {
        yield SuccessConversation(conversation: data);
      }
    } catch (_) {}
  }
}
