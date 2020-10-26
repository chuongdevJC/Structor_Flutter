import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/common/constants/size_constant.dart';
import '../../core/resource/app_colors.dart';
import '../../core/resource/icon_style.dart';
import '../../pages/friend/friend_page.dart';
import '../../pages/message/message_page.dart';
import '../../pages/setting/setting_page.dart';
import '../conversation/recent_conversation_page.dart';
import 'widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  HomePage(this.uid);

  String uid;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

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
    SizeConstant.init(context);
    return Scaffold(
        appBar: appBar(),
        bottomNavigationBar: Material(
          elevation: 0,
          color: AppColors.whiteColor,
          child: TabBar(
            tabs: _tabBarItems,
            controller: _tabController,
          ),
        ),
        body: _tabBarPages());
  }

  static final _tabBarItems = <Tab>[
    Tab(icon: AppIcons.chat_blue),
    Tab(icon: AppIcons.call_blue),
    Tab(icon: AppIcons.people_blue),
    Tab(icon: AppIcons.setting_blue),
  ];

  Widget _tabBarPages() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        RecentConversationsPage(this.widget.uid),
        FriendPage(),
        MessagePage(),
        SettingPage(),
      ],
    );
  }

}
