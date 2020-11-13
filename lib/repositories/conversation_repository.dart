import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/entities/conversation.dart';
import 'package:structure_flutter/data/entities/conversation_snippet.dart';
import 'package:structure_flutter/data/entities/message.dart';
import 'package:structure_flutter/data/source/remote/conversation_remote_datasource.dart';
import 'package:structure_flutter/di/injection.dart';

abstract class ConversationRepository {
  Future<void> updateUserLastSeenTime(String userID);

  Future<void> createConversation(
    String currentID,
    String recipientID,
    String currentUserName,
    String currentUserImage,
    String recipientName,
    String recipientImage,
    MessageType type,
    int unseenCount,
  );

  Future<void> createLastConversation({
    String currentID,
    String recipientID,
    String conversationID,
    String image,
    String lastMessage,
    String name,
    MessageType type,
    int unseenCount,
  });

  Future<void> sendMessage(String conversationID, Message message);

  Future<List<ConversationSnippet>> getLastConversations(String userID);

  Future<Conversation> getConversations(String conversationID);

  Future<List<ConversationSnippet>> getLastConversationByName(
    String searchName,
    String recipientID,
  );
}

@Singleton(as: ConversationRepository)
class ConversationRepositoryImpl extends ConversationRepository {
  final _conversationRemoteDataSource = getIt<ConversationRemoteDataSource>();

  @override
  Future<void> createConversation(
    String currentID,
    String recipientID,
    String currentUserName,
    String currentUserImage,
    String recipientName,
    String recipientImage,
    MessageType type,
    int unseenCount,
  ) {
    return _conversationRemoteDataSource.createConversation(
      currentID,
      recipientID,
      currentUserName,
      currentUserImage,
      recipientName,
      recipientImage,
      type,
      unseenCount,
    );
  }

  @override
  Future<void> createLastConversation({
    String currentID,
    String recipientID,
    String conversationID,
    String image,
    String lastMessage,
    String name,
    MessageType type,
    int unseenCount,
  }) {
    return _conversationRemoteDataSource.createLastConversation(
      currentID: currentID,
      recipientID: recipientID,
      conversationID: conversationID,
      image: image,
      lastMessage: lastMessage,
      name: name,
      type: type,
      unseenCount: unseenCount,
    );
  }

  @override
  Future<void> sendMessage(String conversationID, Message message) {
    return _conversationRemoteDataSource.sendMessage(conversationID, message);
  }

  @override
  Future<void> updateUserLastSeenTime(String userID) {
    return _conversationRemoteDataSource.updateUserLastSeenTime(userID);
  }

  @override
  Future<List<ConversationSnippet>> getLastConversations(String userID) {
    return _conversationRemoteDataSource.getLastConversations(userID);
  }

  @override
  Future<Conversation> getConversations(String conversationID) {
    return _conversationRemoteDataSource.getConversations(conversationID);
  }

  @override
  Future<List<ConversationSnippet>> getLastConversationByName(String searchName, String recipientID) {
    return _conversationRemoteDataSource.getLastConversationByName(searchName,recipientID);
  }
}
