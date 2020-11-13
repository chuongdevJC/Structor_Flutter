import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/data/entities/friend_request.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/widgets/app_bar_widget.dart';
import 'package:structure_flutter/widgets/loading_widget.dart';
import 'package:structure_flutter/widgets/snackbar_widget.dart';
import 'widgets/new_friend_notice.dart';

class DetailNoticePage extends StatefulWidget {
  final String currentUserID;
  final String currentUserName;

  DetailNoticePage({
    Key key,
    this.currentUserID,
    this.currentUserName,
  }) : super(key: key);

  @override
  _DetailNoticePageState createState() => _DetailNoticePageState();
}

class _DetailNoticePageState extends State<DetailNoticePage> {
  final _notificationBloc = getIt<NotificationBloc>();

  final _snackBarWidget = getIt<SnackBarWidget>();

  @override
  void initState() {
    _notificationBloc.add(InitializeNotificationEvent(
      currentUserID: widget.currentUserID,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        isCenterTitle: true,
        elevation: 0,
        title: Row(
          children: [
            AppIcons.notification_important,
            SizedBox(width: 10),
            Text('Thông báo', style: AppStyles.white),
          ],
        ),
      ),
      body: BlocListener(
        cubit: _notificationBloc,
        listener: (BuildContext context, NotificationState state) {
          _snackBarWidget.buildContext = context;
          if (state is LoadingNotification) {
            return Loading();
          }
          if (state is FailureNotification) {
            return Failure();
          }
          if (state is SuccessNotification) {}
        },
        child: BlocBuilder(
          cubit: _notificationBloc,
          builder: (BuildContext context, NotificationState state) {
            if (state is LoadingNotification) {
              return Loading();
            }
            if (state is FailureNotification) {
              return Loading();
            }
            if (state is SuccessNotification) {
              return onSuccessNotification(state.currentFriendsList);
            }
            return Loading();
          },
        ),
      ),
    );
  }

  Widget onSuccessNotification(List<FriendRequest> listFriendRequest) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: ListView(
        children: listFriendRequest
            .map((FriendRequest friendRequest) =>
                _onBuildListFriendRequest(friendRequest))
            .toList(),
      ),
    );
  }

  Widget _onBuildListFriendRequest(FriendRequest friendRequest) {
    return !friendRequest.pending
        ? SizedBox.shrink()
        : NewFriendNotice(
            senderName: friendRequest.name,
            onAcceptPressed: () => _onAcceptOrDeclineFriends(
              currentID: widget.currentUserID,
              recipientID: friendRequest.id,
              pending: false,
              accept: true,
            ),
            onDeclinePressed: () => _onAcceptOrDeclineFriends(
              currentID: widget.currentUserID,
              recipientID: friendRequest.id,
              pending: false,
              accept: false,
            ),
          );
  }

  void _onAcceptOrDeclineFriends({
    String currentID,
    String recipientID,
    bool pending,
    bool accept,
  }) {
    _notificationBloc.add(AcceptMakingFriend(
      currentID,
      recipientID,
      pending,
      accept,
    ));
  }
}
