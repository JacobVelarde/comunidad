

import 'package:auto_size_text/auto_size_text.dart';
import 'package:comunidad/bloc/servicio_bloc.dart';
import 'package:comunidad/model/servicio_result.dart';
import 'package:comunidad/screen/busqueda/lista_municipios_screen.dart';
import 'package:comunidad/tools/banners_admob.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:comunidad/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'catalogo_producto_screen.dart';
import 'lista_negocios_screen.dart';

class MenuTopServiciosScreen extends StatefulWidget {
  @override
  _MenuTopServiciosScreenState createState() => _MenuTopServiciosScreenState();
}

class _MenuTopServiciosScreenState extends State<MenuTopServiciosScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool _showProgress = false;

  ServicioBloc _servicioBloc;
  BannersAdmob _bannersAdmob;

  @override
  void initState() {
    _bannersAdmob = BannersAdmob();
    _controller = AnimationController(vsync: this);
    super.initState();

    _servicioBloc = ServicioBloc();
    _servicioBloc.topServicios();

    _bannersAdmob.large(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _bannersAdmob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MORELOS", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
        ),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            backgroundColor: Colors.white30,
          ),
          color: Colors.black,
          inAsyncCall: _showProgress,
          child: _servicios(),
        ),
      ),
    );
  }

  _servicios(){
    return StreamBuilder(
      stream: _servicioBloc.observableServicioResult,
      builder: (context, snapshot){
        if (snapshot.hasData){
          ServicioResult servicioResult = snapshot.data;
          List<Servicio> _listaServicios = servicioResult.result.object;
          if (_listaServicios != null && _listaServicios.length > 0){
            return CustomScrollView(
              slivers: <Widget>[
                /*SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 80),
                  ]),
                ),*/
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    childAspectRatio: 2
                  ),
                  delegate: SliverChildListDelegate([
                    municipioPrincipal("Cuernavaca", Colors.blueGrey, Colors.white, (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListaNegociosScreen("xdgPv6EKiR")));
                    }),
                    municipioPrincipal("Temixco", Colors.deepPurple, Colors.white, (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListaNegociosScreen("38O6qVrKXY")));
                    }),
                    municipioPrincipal("Jiutepec", Colors.lightBlue, Colors.white, (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListaNegociosScreen("U9Nyon6Gl0")));
                    }),
                    municipioPrincipal("Yautepec", Colors.greenAccent, Colors.white, (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListaNegociosScreen("up2A4uNizy")));
                    }),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 10),
                    CustomButtom(
                      textButton: "BUSCAR MÁS MUNICIPIOS",
                      textColor: Colors.blueGrey,
                      colorButton: Colors.white,
                      callback: (){
                        MiniTools.nextScreen(context, ListaMunicipiosScreen());
                      },
                    ),
                    SizedBox(height: 10),
                    AutoSizeText("TOP 10 NEGOCIOS",
                        minFontSize: 20,
                        maxFontSize: 30,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)
                    ),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    _bodyGrid(_listaServicios),
                  ),
                )
              ],
            );
          }else{
            return Center(child: Text("No hay servicios o negocios disponibles"));
          }
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _bodyGrid(List<Servicio> servicios){
    return servicios.map((servicio) =>
      GestureDetector(
        onTap: (){
          if (servicio.tieneCatalogo != null && servicio.tieneCatalogo){
            MiniTools.nextScreen(context, CatalogoProductoScreen(servicio));
          }
        },
        child: Container(
          height: 120,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                  title: AutoSizeText(servicio.nombre, style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold, fontSize: 17)),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 10),
                      AutoSizeText(servicio.telefono, style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold), textAlign: TextAlign.start)
                    ],
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Icon(Icons.store),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: servicio.tieneCatalogo != null && servicio.tieneCatalogo ? Text("Ver catálogo", style: TextStyle(color: Colors.grey.shade700, decoration: TextDecoration.underline), textAlign: TextAlign.end) : Text("")
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      )
    ).toList();
  }

  municipioPrincipal(String nombre,Color colorCard, Color colorText, GestureTapCallback tapAction){
    return GestureDetector(
      onTap: tapAction,
      child: Card(
        color: colorCard,
        child: Center(
          child: AutoSizeText(
            nombre,
            minFontSize: 12,
            maxFontSize: 20,
            style: TextStyle(
              color: colorText,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  _showModal(bool visible){
    setState(() {
      _showProgress = visible;
    });
  }
}
