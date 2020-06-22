
import 'package:flutter/material.dart';

class MiniTools{

  static hideKeyBoard(BuildContext context){
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static nextScreen(BuildContext context, StatefulWidget screen){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => screen));
  }
}