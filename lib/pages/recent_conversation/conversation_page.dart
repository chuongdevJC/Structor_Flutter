import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/bloc/blocs/realtime_conversation_bloc.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/core/utils/media_utils.dart';
import 'package:structure_flutter/data/entities/conversation.dart';
import 'package:structure_flutter/data/entities/message.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/pages/recent_conversation/widgets/text_message_bubble.dart';
import 'package:structure_flutter/widgets/loading_widget.dart';
import 'package:structure_flutter/widgets/snackbar_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'widgets/bottom_icon.dart';
import 'widgets/emoji_picker.dart';
import 'widgets/image_message_bubble.dart';
import 'widgets/user_image_widget.dart';

class ConversationPage extends StatefulWidget {
  final String conversationID;
  final String currentUid;
  final String recipientID;
  final String receiverName;
  final String receiverImage;
  final String currentUserImage;

  ConversationPage(
    this.conversationID,
    this.currentUid,
    this.recipientID,
    this.receiverName,
    this.receiverImage,
    this.currentUserImage,
  );

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  final _mediaUtil = getIt<MediaUtil>();

  final _snackBar = getIt<SnackBarWidget>();

  final _conversationBloc = getIt<ConversationBloc>();

  final _realtimeConversationBloc = getIt<RealtimeConversationBloc>();

  ScrollController _listViewController = ScrollController();

  File _image;

  bool isMessageTextType = true;

  String _message = "Message";

  var emojiHeight = 0.0;

  TextEditingController textFieldController;

  @override
  void dispose() {
    _listViewController.dispose();
    _conversationBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    _realtimeConversationBloc.add(InitConversation(
      conversationID: widget.conversationID,
    ));

    textFieldController = TextEditingController()
      ..addListener(() {
        setState(() {
          _message = textFieldController.text;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack_white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Text(widget.receiverName, style: AppStyles.white),
      ),
      body: _conversationUI(),
    );
  }

  Widget _conversationUI() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConversationBloc>(
          create: (BuildContext context) => _conversationBloc,
        ),
        BlocProvider<RealtimeConversationBloc>(
          create: (BuildContext context) => _realtimeConversationBloc,
        )
      ],
      child: BlocListener(
        cubit: _realtimeConversationBloc,
        listener: (BuildContext context, ConversationState state) {
          _snackBar.buildContext = context;
          if (state is LoadingConversation) {
            return Loading();
          }
          if (state is FailureConversation) {
            _snackBar.failure("Something went wrong!");
          }
        },
        child: BlocBuilder(
          cubit: _realtimeConversationBloc,
          builder: (BuildContext context, ConversationState state) {
            if (state is LoadingConversation) {
              Loading();
            }
            if (state is SuccessConversation) {
              return _conversationPageUI(context, state.conversation);
            }
            if (state is FailureConversation) {
              Loading();
            }
            return Loading();
          },
        ),
      ),
    );
  }

  Widget _conversationPageUI(
    BuildContext _context,
    Conversation conversations,
  ) {
    return _buildList(conversations);
  }

  Widget _buildList(Conversation conversation) {
    if (conversation != null) {
      if (conversation.messages.isNotEmpty) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                  controller: _listViewController,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: conversation.messages.length,
                  itemBuilder: (BuildContext _context, int _index) {
                    var message = conversation.messages[_index];
                    return _messageListViewChild(message);
                  }),
            ),
            BottomIcon(
              onTapEmoji: () {
                setState(() {
                  emojiHeight = 0.0;
                });
              },
              onSendButton: () {
                setState(() {
                  _onSendMessage();
                });
              },
              onSelectedPhoto: () async {
                File _imageFile = await _mediaUtil.getImageFromLibrary();
                setState(() {
                  _image = _imageFile;
                  isMessageTextType = false;
                  _onSendMessage();
                });
              },
              onSelectedEmoji: () {
                if (emojiHeight == 0.0) {
                  setState(() {
                    emojiHeight = 255.0;
                  });
                } else {
                  setState(() {
                    emojiHeight = 0.0;
                  });
                }
              },
              textFieldController: textFieldController,
            ),
            EmojiesPicker(
              emojiHeight,
              textFieldController,
            ),
          ],
        );
      } else {
        return Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Let's start a conversation!", style: AppStyles.black_24,
                ),
              ),
            ),
            BottomIcon(
              onTapEmoji: () {
                setState(() {
                  emojiHeight = 0.0;
                });
              },
              onSendButton: () {
                setState(() {
                  _onSendMessage();
                });
              },
              onSelectedPhoto: () async {
                File _imageFile = await _mediaUtil.getImageFromLibrary();
                setState(() {
                  _image = _imageFile;
                  isMessageTextType = false;
                  _onSendMessage();
                });
              },
              onSelectedEmoji: () {
                if (emojiHeight == 0.0) {
                  setState(() {
                    emojiHeight = 255.0;
                  });
                } else {
                  setState(() {
                    emojiHeight = 0.0;
                  });
                }
                isMessageTextType = true;
              },
              textFieldController: textFieldController,
            ),
            EmojiesPicker(
              emojiHeight,
              textFieldController,
            ),
          ],
        );
      }
    } else {
      return SpinKitWanderingCubes(
        color: Colors.blue,
        size: 50.0,
      );
    }
  }

  void _onSendMessage() {
    _conversationBloc.add(SendMessageOnPressed(
      senderID: widget.currentUid,
      conversationID: widget.conversationID,
      message: isMessageTextType ? textFieldController.text : _image,
      type: isMessageTextType ? MessageType.Text : MessageType.Image,
      timestamp: Timestamp.fromDate(DateTime.now()),
    ));
    textFieldController.clear();
  }

  Widget _messageListViewChild(Message message) {
    bool _isOwnMessage = message.senderID == widget.currentUid;
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            _isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          !_isOwnMessage ? UserImageWidget(widget.receiverImage) : Container(),
          SizedBox(width: 25),
          message.type == MessageType.Text
              ? TextMessageBubble(
                  _isOwnMessage, message.content, message.timestamp)
              : ImageMessageBubble(
                  _isOwnMessage, message.content, message.timestamp),
          SizedBox(width: 25),
          _isOwnMessage
              ? UserImageWidget(widget.currentUserImage)
              : Container(),
        ],
      ),
    );
  }
}
