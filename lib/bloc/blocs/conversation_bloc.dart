import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/bloc/events/conversation_event.dart';
import 'package:structure_flutter/data/entities/message.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/account_repository.dart';
import 'package:structure_flutter/repositories/conversation_repository.dart';
import 'package:structure_flutter/repositories/friend_repository.dart';
import 'package:structure_flutter/repositories/storage_repository.dart';
import 'package:structure_flutter/repositories/user_repository.dart';
import '../bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc(ConversationState initialState) : super(initialState);

  final _conversationRepository = getIt<ConversationRepository>();

  final _userRepository = getIt<UserRepository>();

  final _storageRepository = getIt<StorageRepository>();

  final _friendRepository = getIt<FriendRepository>();

  @override
  Stream<ConversationState> mapEventToState(ConversationEvent event) async* {
    if (event is InitRecentConversation) {
      yield* _mapRecentConversationToState();
    }
    if (event is InitConversation) {
      yield* _mapConversationToState(event.conversationID);
    }
    if (event is SearchByNameOrEmail) {
      yield* _mapSearchByNameOrEmailToState(
        event.name,
        event.recipientID,
      );
    }
    if (event is SendMessageOnPressed) {
      yield* _mapSendMessageToState(
        event.senderID,
        event.conversationID,
        event.message,
        event.timestamp,
        event.type,
      );
    }
    if (event is SendMakingFriendRequest) {
      yield* _mapSendMakingFriendRequestToState(
        event.currentID,
        event.recipientID,
        event.currentUserName,
        event.currentUserImage,
        event.recipientName,
        event.recipientImage,
        event.type,
        event.unseenCount,
      );
    }
  }

  Stream<ConversationState> _mapRecentConversationToState() async* {
    yield LoadingConversation();
    try {
      final _currentUser = await _userRepository.getUser();
      final _lastConversation =
          await _conversationRepository.getLastConversations(_currentUser.uid);
      yield SuccessConversation(lastConversation: _lastConversation);
    } catch (_) {
      yield FailureConversation();
    }
  }

  Stream<ConversationState> _mapSendMakingFriendRequestToState(
    String currentID,
    String recipientID,
    String currentUserName,
    String currentUserImage,
    String recipientName,
    String recipientImage,
    MessageType type,
    int unseenCount,
  ) async* {
    try {
      await _conversationRepository.createConversation(
        currentID,
        recipientID,
        currentUserName,
        currentUserImage,
        recipientName,
        recipientImage,
        MessageType.Text,
        unseenCount,
      );

      await _friendRepository.makingFriends(
        currentID: currentID,
        recipientID: recipientID,
        recipientName: recipientName,
        currentUserName: currentUserName,
        pending: true,
        accept: false,
      );
      yield SuccessConversation();
    } catch (_) {
      yield FailureConversation();
    }
  }

  Stream<ConversationState> _mapSearchByNameOrEmailToState(
    String userName,
    String recipientID,
  ) async* {
    try {
      final _lastConversation = await _conversationRepository
          .getLastConversationByName(userName, recipientID);
      yield SuccessConversation(lastConversation: _lastConversation);
    } catch (_) {
      yield FailureConversation();
    }
  }

  Stream<ConversationState> _mapConversationToState(
    String conversationID,
  ) async* {
    yield LoadingConversation();
    try {
      final _currentUser =
          await _conversationRepository.getConversations(conversationID);
      yield SuccessConversation(conversation: _currentUser);
    } catch (_) {
      yield FailureConversation();
    }
  }

  Stream<ConversationState> _mapSendMessageToState(
    String senderID,
    String conversationID,
    var message,
    Timestamp timestamp,
    MessageType type,
  ) async* {
    try {
      String _imageURL;
      if (message is File) {
        var result = _storageRepository.uploadUserImage(senderID, message);
        _imageURL = await (await result).ref.getDownloadURL();
      }
      final _message = Message(
        senderID: senderID,
        content: message is File ? _imageURL : message,
        timestamp: timestamp,
        type: type,
      );
      await _conversationRepository.sendMessage(conversationID, _message);
      final _currentUser =
          await _conversationRepository.getConversations(conversationID);
      yield SuccessConversation(conversation: _currentUser);
    } catch (_) {
      yield FailureConversation();
    }
  }
}
