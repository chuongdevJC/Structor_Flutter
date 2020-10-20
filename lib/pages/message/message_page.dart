import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/pages/friend/widgets/search_form.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<MessagePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error ... ");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text(
              'Loading ...',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          );
        }
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SearchForm(),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return _buildRow(document);
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                height: 0.5,
                color: black54,
              ),
              Expanded(
                child: ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return _buildList(document);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: CircleAvatar(
        backgroundColor: redColor,
        radius: 25,
        backgroundImage: NetworkImage(
          '${snapshot.data()['image']}',
        ),
      ),
    );
  }

  String convertTimeStampToHour(DocumentSnapshot document) {
    int timestamp = document.data()['lastSeen'].seconds;
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.jm().format(date);
  }

  Widget _buildList(DocumentSnapshot document) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          '${document.data()['image']}',
        ),
      ),
      title: Text(document.data()['fullName']),
      subtitle: Text('You sent a sticker'),
      trailing: Text('${convertTimeStampToHour(document)}'),
    );
  }
}
