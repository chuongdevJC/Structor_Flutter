import 'package:flutter/material.dart';
import '../../core/common/constants/size_constant.dart';
import '../../core/resource/icon_style.dart';
import '../../core/resource/text_style.dart';

import 'widgets/search_form.dart';

class FriendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConstant().init(context);
    return Scaffold(
      body: Column(
        children: [
          SearchForm(),
          SingleChildScrollView(
            child: Container(
              height: SizeConstant.screenHeight * 0.5,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(int index) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(
        "Person $index",
        style: AppIcons.black_none,
      ),
      trailing: dashboard_none,
    );
  }
}
