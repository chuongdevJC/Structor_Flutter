import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/pages/friend_list/friend_list_page.dart';

class NavMenuDrawer extends StatefulWidget {
  final String currentUserName;
  final String currentUserEmail;

  NavMenuDrawer(
    this.currentUserName,
    this.currentUserEmail,
  );

  @override
  _NavMenuDrawerState createState() => _NavMenuDrawerState();
}

class _NavMenuDrawerState extends State<NavMenuDrawer> {
  final _authenticationBloc = getIt<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(55.0)),
            ),
            child: Center(
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  "${widget.currentUserName}",
                  style: AppStyles.white_16,
                ),
                accountEmail: Text(
                  "${widget.currentUserEmail}",
                  style: AppStyles.white_16,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                  child: Text(
                    "${widget.currentUserName.substring(0, 1)}",
                    style: AppStyles.back_28,
                  ),
                ),
              ),
            )),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: AppIcons.people,
                title: Text('Kết bạn'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FriendListPage()));
                },
              ),
              ListTile(
                leading: AppIcons.search,
                title: Text('Tìm kiếm gần đây'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FriendListPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Đăng xuất'),
                onTap: () {
                  _authenticationBloc.add(LoggedOut());
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
