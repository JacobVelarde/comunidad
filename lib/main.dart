import 'package:comunidad/screen/menu_principal_screen.dart';
import 'package:flutter/material.dart';

void main(){
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MenuPrincipalScreen(),
        theme: ThemeData(
            primaryColor: Colors.indigo.shade900
        ),
      )
  );
}