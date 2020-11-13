import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:structure_flutter/data/entities/message.dart';

abstract class ConversationEvent extends Equatable {
  ConversationEvent([List props = const []]) : super();
}

class InitRecentConversation extends ConversationEvent {
  final String message = "InitializeLoadData";

  @override
  String toString() {
    return message;
  }

  @override
  List<Object> get props => [message];
}

class InitConversation extends ConversationEvent {
  final String message = "InitConversation";
  String conversationID;

  InitConversation({this.conversationID});

  @override
  String toString() {
    return message;
  }

  @override
  List<Object> get props => [message, conversationID];
}

class SendMessageOnPressed extends ConversationEvent {
  String senderID;
  String conversationID;
  dynamic message;
  Timestamp timestamp;
  MessageType type;

  SendMessageOnPressed({
    this.senderID,
    this.conversationID,
    this.message,
    this.timestamp,
    this.type,
  });

  @override
  List<Object> get props => [
        senderID,
        conversationID,
        message,
        timestamp,
        type,
      ];
}

class SendMakingFriendRequest extends ConversationEvent {
  String currentID;
  String recipientID;
  String currentUserName;
  String currentUserImage;
  String recipientName;
  String recipientImage;
  MessageType type;
  int unseenCount;

  SendMakingFriendRequest({
    this.currentID,
    this.recipientID,
    this.currentUserName,
    this.currentUserImage,
    this.recipientName,
    this.recipientImage,
    this.type,
    this.unseenCount,
  });

  @override
  List<Object> get props => [
        currentID,
        recipientID,
        currentUserName,
        currentUserImage,
        recipientName,
        recipientImage,
        type,
        unseenCount,
      ];
}

class SearchByNameOrEmail extends ConversationEvent {
  String name;
  String recipientID;

  SearchByNameOrEmail({this.name, this.recipientID});

  @override
  List<Object> get props => [name, recipientID];
}
