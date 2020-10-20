import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/core/common/constants/size_constant.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/pages/friend/friend_page.dart';
import 'package:structure_flutter/pages/message/message_page.dart';
import 'package:structure_flutter/pages/setting/setting_page.dart';
import 'file:///G:/Project/jobchat/Structure_Flutter/lib/pages/conversation/recent_conversation_page.dart';
import 'widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConstant().init(context);
    return Scaffold(
        appBar: appBar(),
        bottomNavigationBar: Material(
          elevation: 0,
          color: whiteColor,
          child: TabBar(
            tabs: _tabBarItems,
            controller: _tabController,
          ),
        ),
        body: _tabBarPages());
  }

  static final _tabBarItems = <Tab>[
    Tab(icon: chat_blue),
    Tab(icon: call_blue),
    Tab(icon: people_blue),
    Tab(icon: setting_blue),
  ];

  Widget _tabBarPages() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        RecentConversationsPage(),
        FriendPage(),
        MessagePage(),
        SettingPage(),
      ],
    );
  }
}
