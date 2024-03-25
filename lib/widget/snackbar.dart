import 'package:flutter/material.dart';
import 'package:trackexx/theme/color.dart';

class CustomSnackBar {
  GlobalKey<ScaffoldState> scaffoldKey;
  bool haserror = false;
  String title, actionTile;
  Function() onPressed;
  bool isfloating;

  CustomSnackBar({required this.scaffoldKey,required this.title,required this.haserror,required this.actionTile,
    required  this.isfloating,required this.onPressed});

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: haserror ? errorColor : succses,
      behavior: isfloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      margin: isfloating ? EdgeInsets.all(20) : null,
      duration: Duration(seconds: 2),
      action: actionTile != ""
          ? SnackBarAction(
              label: actionTile,
              onPressed: onPressed == null
                  ? () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }
                  : onPressed,
              textColor: white,
            )
          : null,
    ));
  }
}
