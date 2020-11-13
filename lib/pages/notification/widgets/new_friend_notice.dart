import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

class NewFriendNotice extends StatelessWidget {
  final String senderName;
  final VoidCallback onAcceptPressed;
  final VoidCallback onDeclinePressed;

  NewFriendNotice({
    this.senderName,
    this.onAcceptPressed,
    this.onDeclinePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        title: Text(
          'Thông báo !',
          style: AppStyles.black,
        ),
        subtitle: Container(
          child: Column(
            children: [
              Text("Bạn nhận được lời mời kết bạn từ $senderName",
                  style: AppStyles.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlatButton(
                    onPressed: onAcceptPressed,
                    child: Text('Accept', style: TextStyle(color: Colors.blue)),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.blue,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  FlatButton(
                    onPressed: onDeclinePressed,
                    child: Text('Decline'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
