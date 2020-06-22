
import 'package:auto_size_text/auto_size_text.dart';
import 'package:comunidad/screen/admin/login_negocios_screen.dart';
import 'package:comunidad/screen/sencillo/registrar_negocio_screen.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:flutter/material.dart';

class OpcionRegistrarNegocioScrenn extends StatefulWidget {
  @override
  _OpcionRegistrarNegocioScrennState createState() => _OpcionRegistrarNegocioScrennState();
}

class _OpcionRegistrarNegocioScrennState extends State<OpcionRegistrarNegocioScrenn> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Elige una opción", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _opcionAnuncioRapido(),
            SizedBox(height: 50),
            _opcionAnuncioCatalogo()
            /*CustomButtom(
              textButton: "Anuncion rápido",
              textColor: Colors.white,
              colorButton: Colors.green,
              callback: (){
                MiniTools.nextScreen(context, RegistrarNegocioScreen());
              },
            ),
            CustomButtom(
              textButton: "Anuncio con catálogo",
              textColor: Colors.blueGrey,
              colorButton: Colors.white,
              callback: (){
                MiniTools.nextScreen(context, LoginNegociosScreen());
              },
            )*/
          ],
        ),
      ),
    );
  }

  _opcionAnuncioRapido(){
    return GestureDetector(
      onTap: (){
        MiniTools.nextScreen(context, RegistrarNegocioScreen());
      },
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          color: Colors.green,
          child: Center(
            child: AutoSizeText(
              "Agregar servicio o negocio sin catálogo",
              minFontSize: 12,
              maxFontSize: 20,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }

  _opcionAnuncioCatalogo(){
    return GestureDetector(
      onTap: (){
        MiniTools.nextScreen(context, LoginNegociosScreen());
      },
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          color: Colors.white,
          child: Center(
            child: AutoSizeText(
              "Agregar servicio o negocio con catálogo",
              minFontSize: 12,
              maxFontSize: 20,
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
