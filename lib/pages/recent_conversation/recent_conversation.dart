import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/core/utils/date_time_utils.dart';
import 'package:structure_flutter/data/entities/conversation_snippet.dart';
import 'package:structure_flutter/data/entities/message.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/pages/recent_conversation/conversation_page.dart';
import 'package:structure_flutter/widgets/loading_widget.dart';
import 'package:structure_flutter/widgets/snackbar_widget.dart';
import 'widgets/menu_drawer.dart';
import 'widgets/search_bar.dart';

class RecentConversationScreen extends StatefulWidget {
  String currentUid;
  String currentUserName;

  String currentUserEmail;
  String currentUserImage;

  RecentConversationScreen(
    this.currentUid,
    this.currentUserName,
    this.currentUserEmail,
    this.currentUserImage,
  );

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<RecentConversationScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  final _snackBar = getIt<SnackBarWidget>();

  final _conversationBloc = getIt<ConversationBloc>();

  final _dateTimeUtils = getIt<DateTimeUtils>();

  String get currentUid => widget.currentUid;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _conversationBloc.add(InitRecentConversation());
  }

  List<ConversationSnippet> filteredUsers = List();

  bool isSelectedSearchBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: NavMenuDrawer(
          widget.currentUserName,
          widget.currentUserEmail,
        ),
      ),
      appBar: AppBar(
        title: isSelectedSearchBar
            ? SearchBar(
                onTextChanged: (searchText) {
                  setState(() {
                    _onSearchByNameOrEmail(searchText);
                  });
                },
              )
            : Text('Home'),
        elevation: 0,
        leading: IconButton(
          icon: AppIcons.menu,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: isSelectedSearchBar ? AppIcons.cancel : AppIcons.search,
            onPressed: () {
              setState(() {
                isSelectedSearchBar = !isSelectedSearchBar;
              });
            },
          ),
          IconButton(icon: AppIcons.more_vert, onPressed: () {})
        ],
      ),
      body: BlocListener(
        cubit: _conversationBloc,
        listener: (BuildContext context, ConversationState state) {
          _snackBar.buildContext = context;
          if (state is LoadingConversation) {
            return Loading();
          }
          if (state is FailureConversation) {
            _snackBar.failure("Something went wrong!");
          }
          if (state is SuccessConversation) {}
        },
        child: BlocBuilder(
          cubit: _conversationBloc,
          builder: (BuildContext context, ConversationState state) {
            if (state is LoadingConversation) {
              Loading();
            }
            if (state is SuccessConversation) {
              return _onSuccessLoadData(state.lastConversation);
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

  Widget _onSuccessLoadData(List<ConversationSnippet> conversations) {
    if (conversations != null) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: conversations.map((ConversationSnippet conversation) {
                  return _buildRow(conversation);
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              height: 0.5,
              color: AppColors.black54,
            ),
            Expanded(
              child: ListView(
                children: conversations.map((ConversationSnippet conversation) {
                  return _buildList(conversation);
                }).toList(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text('Lets start conversations'),
      );
    }
  }

  Widget _buildRow(ConversationSnippet account) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.blueAccent,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.double_spanish_white,
            backgroundImage: NetworkImage(
              '${account.image}',
            ),
          ),
        ));
  }

  Widget _buildList(ConversationSnippet conversation) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationPage(
                conversation.conversationID,
                widget.currentUid,
                conversation.recipientID,
                conversation.name,
                conversation.image,
                widget.currentUserImage,
              ),
            ));
      },
      leading: CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.blueAccent,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.double_spanish_white,
            backgroundImage: NetworkImage(conversation.image),
          )),
      title: Text(conversation.name),
      subtitle: Text(conversation.type == MessageType.Text
          ? conversation.lastMessage
          : "Attachment: Image"),
      trailing: Text(
          '${_dateTimeUtils.convertTimeStampToHour(conversation.timestamp.millisecondsSinceEpoch)}'),
    );
  }

  void _onSearchByNameOrEmail(String textChange) {
    _conversationBloc.add(SearchByNameOrEmail(
      name: textChange,
      recipientID: currentUid,
    ));
  }
}
