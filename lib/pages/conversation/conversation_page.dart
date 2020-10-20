import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structure_flutter/bloc/blocs/auth_provider.dart';
import 'package:structure_flutter/core/common/constants/size_constant.dart';
import 'package:structure_flutter/core/extension/media_extension.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/data/entities/conversation.dart';
import 'package:structure_flutter/data/entities/message.dart';
import 'package:structure_flutter/repositories/account_repository.dart';
import 'package:structure_flutter/repositories/storage_repository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class ConversationPage extends StatefulWidget {
  String _conversationID;
  String _receiverID;
  String _receiverImage;
  String _receiverName;

  ConversationPage(this._conversationID, this._receiverID, this._receiverName,
      this._receiverImage);

  @override
  State<StatefulWidget> createState() {
    return _ConversationPageState();
  }
}

class _ConversationPageState extends State<ConversationPage> {
  GlobalKey<FormState> _formKey;
  ScrollController _listViewController;
  AuthProvider _auth;
  String _messageText;

  String _UID_USER = "71f3FJ5nzVcxUbKhUUpAo5KmDsA2";

  _ConversationPageState() {
    _formKey = GlobalKey<FormState>();
    _listViewController = ScrollController();
    _messageText = "";
  }

  @override
  Widget build(BuildContext context) {
    SizeConstant().init(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 246, 247, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: arrowbackios_black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 10,
        backgroundColor: whiteColor,
        title: Text(this.widget._receiverName, style: black_20),
      ),
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationPageUI(),
      ),
    );
  }

  Widget _conversationPageUI() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            _messageListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _messageField(_context),
            ),
          ],
        );
      },
    );
  }

  Widget _messageListView() {
    return Container(
      height: SizeConstant.screenHeight * 0.75,
      width: SizeConstant.screenWidth,
      child: StreamBuilder<Conversation>(
        stream: AccountRepositoryImpl.instance
            .getConversation(this.widget._conversationID),
        builder: (BuildContext _context, _snapshot) {
          Timer(
            Duration(milliseconds: 50),
            () => {
              _listViewController
                  .jumpTo(_listViewController.position.maxScrollExtent),
            },
          );
          var _conversationData = _snapshot.data;
          if (_conversationData != null) {
            if (_conversationData.messages.length != 0) {
              return ListView.builder(
                controller: _listViewController,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: _conversationData.messages.length,
                itemBuilder: (BuildContext _context, int _index) {
                  var _message = _conversationData.messages[_index];
                  bool _isOwnMessage = _message.senderID == _UID_USER;
                  return _messageListViewChild(_isOwnMessage, _message);
                },
              );
            } else {
              return Align(
                alignment: Alignment.center,
                child: Text("Let's start a conversation!"),
              );
            }
          } else {
            return SpinKitWanderingCubes(
              color: whiteColor,
              size: 50.0,
            );
          }
        },
      ),
    );
  }

  Widget _messageListViewChild(bool _isOwnMessage, Message _message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            _isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          !_isOwnMessage ? _userImageWidget() : Container(),
          SizedBox(width: SizeConstant.screenWidth * 0.02),
          _message.type == MessageType.Text
              ? _textMessageBubble(
                  _isOwnMessage, _message.content, _message.timestamp)
              : _imageMessageBubble(
                  _isOwnMessage, _message.content, _message.timestamp),
        ],
      ),
    );
  }

  Widget _userImageWidget() {
    double _imageRadius = SizeConstant.screenHeight * 0.05;
    return Container(
      height: _imageRadius,
      width: _imageRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(this.widget._receiverImage),
        ),
      ),
    );
  }

  Widget _textMessageBubble(
      bool _isOwnMessage, String _message, Timestamp _timestamp) {
    List<Color> _colorScheme = _isOwnMessage
        ? [Color.fromRGBO(0, 120, 255, 1), Color.fromRGBO(0, 120, 255, 1)]
        : [Color.fromRGBO(178, 222, 236, 1), Color.fromRGBO(178, 222, 236, 1)];
    return Container(
      height: SizeConstant.screenHeight * 0.08 + (_message.length / 20 * 5.0),
      width: SizeConstant.screenWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            _message,
            style: TextStyle(color: whiteColor),
          ),
          Text(
            timeago.format(_timestamp.toDate()),
            style: TextStyle(color: whiteColor),
          ),
        ],
      ),
    );
  }

  Widget _imageMessageBubble(
      bool _isOwnMessage, String _imageURL, Timestamp _timestamp) {
    List<Color> _colorScheme = _isOwnMessage
        ? [blueNormalColor, lightBlueColor]
        : [whiteColor, redColor];
    DecorationImage _image =
        DecorationImage(image: NetworkImage(_imageURL), fit: BoxFit.cover);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: SizeConstant.screenHeight * 0.30,
            width: SizeConstant.screenWidth * 0.40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image,
            ),
          ),
          Text(
            timeago.format(_timestamp.toDate()),
            style: black_none,
          ),
        ],
      ),
    );
  }

  Widget _messageField(BuildContext _context) {
    return Container(
      height: SizeConstant.screenHeight * 0.08,
      decoration: BoxDecoration(
        color: whiteColor,
        // borderRadius: BorderRadius.circular(20),
      ),
      // margin: EdgeInsets.symmetric(
      //     horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.03),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _imageMessageButton(),
            _emojiButton(),
            _messageTextField(),
            _microButton(),
            _sendMessageButton(_context),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: SizeConstant.screenWidth * 0.55,
      child: TextFormField(
        validator: (_input) {
          if (_input.length == 0) {
            return "Please enter a message";
          }
          return null;
        },
        onChanged: (_input) {
          _formKey.currentState.save();
        },
        onSaved: (_input) {
          setState(() {
            _messageText = _input;
          });
        },
        cursorColor: whiteColor,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: "Start Typing..."),
        autocorrect: false,
      ),
    );
  }

  Widget _sendMessageButton(BuildContext _context) {
    return Container(
      // height: _deviceHeight * 0.05,
      width: SizeConstant.screenWidth * 0.05,
      child: IconButton(
          icon: send_blue,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              AccountRepositoryImpl.instance.sendMessage(
                this.widget._conversationID,
                Message(
                    content: _messageText,
                    timestamp: Timestamp.now(),
                    senderID: _UID_USER,
                    type: MessageType.Text),
              );
              _formKey.currentState.reset();
              FocusScope.of(_context).unfocus();
            }
          }),
    );
  }

  Widget _imageMessageButton() {
    return Container(
      height: SizeConstant.screenHeight * 0.06,
      width: SizeConstant.screenWidth * 0.1,
      child: FloatingActionButton(
        onPressed: () async {
          var _image = await MediaExtension.instance.getImageFromLibrary();
          if (_image != null) {
            var _result = await StorageRepositoryImpl.instance
                .uploadMediaMessage(_UID_USER, _image);
            var _imageURL = await _result.ref.getDownloadURL();
            await AccountRepositoryImpl.instance.sendMessage(
              this.widget._conversationID,
              Message(
                  content: _imageURL,
                  senderID: _UID_USER,
                  timestamp: Timestamp.now(),
                  type: MessageType.Image),
            );
          }
        },
        child: camera_none,
      ),
    );
  }

  Widget _microButton() {
    return Container(
      child: micro_blue,
    );
  }

  Widget _emojiButton() {
    return Container(
      child: emoticon_blue_25,
    );
  }
}
