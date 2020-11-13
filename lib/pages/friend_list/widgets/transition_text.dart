import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

class TransitionText extends StatefulWidget {
  final bool show;
  final bool sent;

  TransitionText(this.show, this.sent);

  @override
  _State createState() => _State();
}

class _State extends State<TransitionText> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 600),
          child: widget.show ? SizedBox(width: 10.0) : Container(),
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 200),
          child: widget.show
              ? Text(
                  "Send",
                  style: AppStyles.white,
                )
              : Container(),
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 200),
          child: widget.sent
              ? Icon(
                  Icons.done,
                  color: AppColors.white,
                )
              : Container(),
        ),
        AnimatedSize(
          vsync: this,
          alignment: Alignment.topLeft,
          duration: Duration(milliseconds: 600),
          child: widget.sent ? SizedBox(width: 10.0) : Container(),
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 200),
          child: widget.sent
              ? Center(
                  child: Text(
                    "Done",
                    style: AppStyles.white,
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
