import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:structure_flutter/bloc/blocs/auth_provider.dart';
import 'package:structure_flutter/core/common/constants/size_constant.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/data/entities/conversation.dart';
import 'package:structure_flutter/data/entities/message.dart';
import 'package:structure_flutter/repositories/account_repository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'conversation_page.dart';

class RecentConversationsPage extends StatelessWidget {
  RecentConversationsPage();

  @override
  Widget build(BuildContext context) {
    SizeConstant().init(context);
    return Container(
      height: SizeConstant.screenHeight,
      width: SizeConstant.screenWidth,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationsListViewWidget(),
      ),
    );
  }

  Widget _conversationsListViewWidget() {
    return Builder(
      builder: (BuildContext _context) {
        var _auth = Provider.of<AuthProvider>(_context);
        return Container(
            height: SizeConstant.screenHeight,
            width: SizeConstant.screenWidth,
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: black12_none,
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      prefixIcon: search_blue,
                      hintText: 'Search',
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: StreamBuilder<List<ConversationSnippet>>(
                      stream: AccountRepositoryImpl.instance
                          .getUserConversations("71f3FJ5nzVcxUbKhUUpAo5KmDsA2"),
                      builder: (_context, _snapshot) {
                        var _data = _snapshot.data;
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              return _buildRow(_snapshot, index);
                            });
                      }),
                ),
                Container(
                  height: SizeConstant.screenHeight * 0.55,
                  child: StreamBuilder<List<ConversationSnippet>>(
                    stream: AccountRepositoryImpl.instance
                        .getUserConversations("71f3FJ5nzVcxUbKhUUpAo5KmDsA2"),
                    builder: (_context, _snapshot) {
                      var _data = _snapshot.data;
                      print("DATA: $_data");
                      if (_data != null) {
                        _data.removeWhere((_c) {
                          return _c.timestamp == null;
                        });
                        return _data.length != 0
                            ? ListView.builder(
                                itemCount: _data.length,
                                itemBuilder: (_context, _index) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        _context,
                                        MaterialPageRoute(
                                          builder: (BuildContext _context) {
                                            return ConversationPage(
                                                _data[_index].conversationID,
                                                _data[_index].id,
                                                _data[_index].name,
                                                _data[_index].image);
                                          },
                                        ),
                                      );
                                    },
                                    title: Text(_data[_index].name),
                                    subtitle: Text(
                                        _data[_index].type == MessageType.Text
                                            ? _data[_index].lastMessage
                                            : "Attachment: Image"),
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(_data[_index].image),
                                        ),
                                      ),
                                    ),
                                    trailing: _listTileTrailingWidgets(
                                        _data[_index].timestamp),
                                  );
                                },
                              )
                            : Align(
                                child: Text(
                                  "No Conversations Yet!",
                                  style: white30_15,
                                ),
                              );
                      } else {
                        return SpinKitWanderingCubes(
                          color: blueNormalColor,
                          size: 50.0,
                        );
                      }
                    },
                  ),
                )
              ],
            ));
      },
    );
  }

  Widget _listTileTrailingWidgets(Timestamp _lastMessageTimestamp) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "Last Message",
          style: TextStyle(fontSize: 15),
        ),
        Text(
          timeago.format(_lastMessageTimestamp.toDate()),
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildRow(
      AsyncSnapshot<List<ConversationSnippet>> snapshot, int index) {
    var data = snapshot.data;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: CircleAvatar(
        backgroundColor: redColor,
        radius: 25,
        backgroundImage: NetworkImage(
          '${data[index].image}',
        ),
      ),
    );
  }
}
