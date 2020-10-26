import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  Text,
  Image,
}

class Message {
  final String senderID;
  final String content;
  final Timestamp timestamp;
  final MessageType type;

  Message({
    this.senderID,
    this.content,
    this.timestamp,
    this.type,
  });

  factory Message.parseDataToObject(dynamic _m){
    return Message(
        type: _m["type"] == "text" ? MessageType.Text : MessageType.Image,
        content: _m["message"],
        timestamp: _m["timestamp"],
        senderID: _m["senderID"]);
  }

}
