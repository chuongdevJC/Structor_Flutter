import 'package:flutter/material.dart';
import 'widgets/search_form.dart';
import '../../core/resource/app_colors.dart';
import '../../data/entities/conversation.dart';
import '../../repositories/account_repository.dart';
import '../../core/common/constants/size_constant.dart';
import '../../core/resource/icon_style.dart';
import '../../core/resource/text_style.dart';


class FriendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConstant.init(context);
    return Scaffold(
      body: Column(
        children: [
          SearchForm(),
          SingleChildScrollView(
            child: StreamBuilder<List<ConversationSnippet>>(
              stream: AccountRepositoryImpl.instance.getUserConversations("wLyFYdCqHRfT340SFawP3DoNU5X2"),
                builder: (_context, _snapshot) {
                  var _data = _snapshot.data;
                  return ListView.builder(itemBuilder: (BuildContext context, int index){
                  return _buildList(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
      AsyncSnapshot<List<ConversationSnippet>> snapshot, int index) {
    var data = snapshot.data;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: CircleAvatar(
        backgroundColor: AppColors.redColor,
        radius: 25,
        backgroundImage: NetworkImage(
          '${data[index].image}',
        ),
      ),
    );
  }

  Widget _buildList(int index) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(
        "Person $index",
        style: AppStyles.black_none,
      ),
      trailing: AppIcons.dashboard_none,
    );
  }

}
