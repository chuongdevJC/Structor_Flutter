import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/core/common/helpers/random_helper.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/assets_images.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/data/entities/account.dart';
import 'package:structure_flutter/data/entities/message.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/pages/recent_conversation/widgets/search_bar.dart';
import 'package:structure_flutter/repositories/account_repository.dart';
import 'package:structure_flutter/repositories/conversation_repository.dart';
import 'package:structure_flutter/repositories/friend_repository.dart';
import 'package:structure_flutter/widgets/app_bar_widget.dart';
import 'package:structure_flutter/widgets/loading_widget.dart';
import 'package:structure_flutter/widgets/snackbar_widget.dart';

import 'widgets/friend_profile.dart';

class FriendListPage extends StatefulWidget {
  String currentUid;
  String currentUserName;
  String currentUserImage;

  FriendListPage(
      {this.currentUid, this.currentUserName, this.currentUserImage});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<FriendListPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  final _snackBar = getIt<SnackBarWidget>();

  final _friendBloc = getIt<FriendBloc>();

  final _conversationBloc = getIt<ConversationBloc>();

  final _random = getIt<RandomHelper>();

  @override
  void dispose() {
    _friendBloc.close();
    super.dispose();
  }

  bool isSelectedSearchBar = false;

  @override
  void initState() {
    _friendBloc.add(InitializeFriendList(
      widget.currentUid,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        elevation: 0,
        title: isSelectedSearchBar
            ? SearchBar(
                onTextChanged: (searchText) {
                  setState(() {
                    _onSearchByNameOrEmail(searchText);
                  });
                },
              )
            : Text(''),
        leading: AppIcons.account_box_rounded,
        actions: <Widget>[
          IconButton(
            icon: isSelectedSearchBar ? AppIcons.cancel : AppIcons.search,
            onPressed: () {
              setState(() {
                isSelectedSearchBar = !isSelectedSearchBar;
              });
            },
          ),
        ],
      ),
      body: BlocListener(
        cubit: _friendBloc,
        listener: (BuildContext context, FriendState state) {
          _snackBar.buildContext = context;
          if (state is Loading) {
            Loading();
          }
          if (state is Failure) {
            _snackBar.failure("Something went wrong !");
          }
          if (state is Success) {
            _snackBar.success("Looking for friends near you !");
          }
        },
        child: _onRenderGridFriend(),
      ),
    );
  }

  Widget _onRenderGridFriend() {
    return BlocBuilder(
      cubit: _friendBloc,
      builder: (BuildContext context, FriendState state) {
        if (state is Loading) {
          return Loading();
        }
        if (state is Failure) {
          _snackBar.failure("Something went wrong !");
        }
        if (state is Success) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: GridView.count(
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  crossAxisCount: 2,
                  children: state.accounts.map((Account account) {
                    return _buildGridView(account);
                  }).toList(),
                ),
              ),
            ],
          );
        }
        return Loading();
      },
    );
  }

  Widget _buildGridView(Account recipient) {
    return FriendProfile(
      name: recipient.name,
      image: recipient.image,
      followers: _random.followers(),
      colors: _random.colors(),
      feed: _random.feed(),
      onPressed: () => _onPressed(
        recipient.id,
        recipient.name,
        recipient.image,
      ),
      isActiveButton: true,
    );
  }

  void _onPressed(
    String recipientID,
    String recipientName,
    String recipientImage,
  ) {
    _conversationBloc.add(SendMakingFriendRequest(
      currentID: widget.currentUid,
      recipientID: recipientID,
      currentUserName: widget.currentUserName,
      currentUserImage: widget.currentUserImage,
      recipientName: recipientName,
      recipientImage: recipientImage,
      type: MessageType.Text,
      unseenCount: 12,
    ));
  }

  void _onSearchByNameOrEmail(String textChange) {
    _conversationBloc.add(SearchByNameOrEmail(
      name: textChange,
      recipientID: widget.currentUid,
    ));
  }
}
