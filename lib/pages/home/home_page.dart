import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/pages/friend_list/friend_list_page.dart';
import 'package:structure_flutter/pages/notification/detail_notice_page.dart';
import 'package:structure_flutter/pages/setting/setting_page.dart';

import '../../core/resource/icon_style.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  User get user => widget.user;

  TabController _tabController;

  static final _tabBarItems = <Tab>[
    Tab(icon: AppIcons.chat_blue),
    Tab(icon: AppIcons.call_blue),
    Tab(icon: AppIcons.notifications_blue),
    Tab(icon: AppIcons.setting_blue),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _tabBarItems.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        elevation: 0,
        color: AppColors.white,
        child: TabBar(
          tabs: _tabBarItems,
          controller: _tabController,
        ),
      ),
      body: _tabBarPages(),
    );
  }

  Widget _tabBarPages() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        Text('Recent conversation page !'),
        FriendListPage(user.uid, user.displayName),
        DetailNoticePage(
          currentUserID: user.uid,
          currentUserName: user.displayName,
        ),
        SettingPage(user.displayName, user.photoURL),
      ],
    );
  }
}
