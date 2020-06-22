
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget{

  final String textButton;
  final Color textColor;
  final Color colorButton;
  final VoidCallback callback;

  CustomButtom({
    this.textButton,
    this.textColor,
    this.colorButton,
    this.callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Material(
        elevation: 10,
        color: colorButton?? Colors.green.shade600,
        borderRadius: BorderRadius.circular(10.0),
        child: FlatButton(
          child: AutoSizeText(textButton,
              minFontSize: 10,
              maxFontSize: 15,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 20,
                  color: textColor?? Colors.white
              ),
              textAlign: TextAlign.center),
          onPressed: callback,
        ),
      ),
    );
  }
}