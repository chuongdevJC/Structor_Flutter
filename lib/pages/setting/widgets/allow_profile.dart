import 'package:flutter/material.dart';
import '../../../core/resource/app_colors.dart';
import '../../../core/resource/text_style.dart';

class AllowProfile extends StatefulWidget {
  String allow;

  AllowProfile(this.allow);

  @override
  _AllowProfileState createState() => _AllowProfileState(this.allow);
}

class _AllowProfileState extends State<AllowProfile> {
  String allow;

  _AllowProfileState(this.allow);

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Text('${this.allow}', style: AppIcons.font_14),
          ),
          Container(
            width: 55,
            height: 40,
            child: Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
              activeTrackColor: AppColors.lightGreenAccentColor,
              activeColor: AppColors.greenColor,
            ),
          ),
        ],
      ),
    );
  }
}
