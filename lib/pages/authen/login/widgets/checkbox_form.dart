import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

class CheckBoxForm extends StatefulWidget {
  @override
  _CheckBoxFormState createState() => _CheckBoxFormState();
}

class _CheckBoxFormState extends State<CheckBoxForm> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value;
                });
              },
            ),
            Text(
              'Remember',
              style: black_12,
            )
          ],
        ));
  }
}
