import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/account_repository.dart';
import 'package:structure_flutter/widgets/snackbar_widget.dart';

import '../../core/resource/app_colors.dart';

class RecentConversationScreen extends StatefulWidget {
  final User mUser;

  RecentConversationScreen(this.mUser);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<RecentConversationScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  final _snackBar = getIt<SnackBarWidget>();

  final _accountRepository = getIt<AccountRepository>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(includeMetadataChanges: true),
        builder:
            (BuildContext _context, AsyncSnapshot<QuerySnapshot> snapshot) {
          _snackBar.buildContext = _context;
          if (snapshot.hasError) {
            _snackBar.failure("Something went wrong !");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading();
          }
          if (snapshot.hasData) {
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
                      children: _accountRepository
                          .getAllUsers(snapshot)
                          .map((DocumentSnapshot document) {
                        return _buildRow(document);
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
                      children: _accountRepository
                          .getAllUsers(snapshot)
                          .map((DocumentSnapshot document) {
                        return _buildList(document);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
          return _loading();
        });
  }

  Widget _buildRow(DocumentSnapshot document) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          '${document.data()['image']}',
        ),
      ),
    );
  }

  String convertTimeStampToHour(Map<String, dynamic> data) {
    int timestamp = data['lastSeen'].seconds;
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.jm().format(date);
  }

  Widget _buildList(DocumentSnapshot document) {
    String _conversationID = document.data()['id'];
    String _id = document.data()['id'];
    String _name = document.data()['name'];
    String _image = document.data()['image'];

    return ListTile(
      onTap: () {
        print(widget.mUser.uid.toString());
        print(_id);
        _accountRepository.createLastConversation(widget.mUser.uid, _id,
            _conversationID, _image, "Hello world!", _name, 4);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ConversationScreen(
        //             _conversationID,
        //             _id,
        //             _name,
        //             _image,
        //           )),
        // );
      },
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.red,
        backgroundImage: NetworkImage('${document.data()['image']}'),
      ),
      title: Text(document.data()['name']),
      subtitle: Text('You sent a sticker'),
      trailing: Text('${convertTimeStampToHour(document.data())}'),
    );
  }

  Widget _loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Loading ...',
            style: AppStyles.black38_16,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
