
import 'package:comunidad/bloc/version_app_bloc.dart';
import 'package:comunidad/provider/push_notifications_provider.dart';
import 'package:comunidad/screen/busqueda/lista_municipios_screen.dart';
import 'package:comunidad/screen/admin/login_negocios_screen.dart';
import 'package:comunidad/screen/busqueda/menu_top_servicios_screen.dart';
import 'package:comunidad/screen/opcion_registrar_negocio_screen.dart';
import 'package:comunidad/screen/sencillo/registrar_negocio_screen.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:comunidad/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MenuPrincipalScreen extends StatefulWidget {
  @override
  _MenuPrincipalScreenState createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  //VERSION APP
  final String _versionApp = "1.0.0";
  //VERSION APP

  bool _showProgress = false;

  @override
  void initState() {
    super.initState();

    PushNotificationProvider pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotifications();
    //_checkVersionApp();

  }

  _checkVersionApp(){

    versionAppBloc.observableVersionApp.listen((event) {
      if (event != null){
        _showModal(false);
        if (event.result.code != 200){
          _showMessage(body: "Necesitas actualizar la aplicacion");
        }
      }
    });

    _showModal(true);
    versionAppBloc.versionApp(_versionApp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            backgroundColor: Colors.white30,
          ),
          color: Colors.black,
          inAsyncCall: _showProgress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Comunidad",
                textAlign: TextAlign.center,
                style:TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 50
                ),
              ),
              SizedBox(height: 10),
              Text("Catálogo digital de productos\ny servicios de Morelos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 100),
              _buttonBuscarNegocio(),
              SizedBox(height: 15),
              _buttonRegistrarNegocio(),
              SizedBox(height: 50),
              /*GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginNegociosScreen()));
                  },
                child:Text("Soy dueño o necesito un espacio publicitario\ncon catalogo",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  _buttonBuscarNegocio(){
    return CustomButtom(
      textButton: "Buscar negocio o servicio",
      colorButton: Colors.green.shade600,
      callback: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MenuTopServiciosScreen()));
      },
    );
  }

  _buttonRegistrarNegocio(){
    return GestureDetector(
      onTap: (){
        MiniTools.nextScreen(context, OpcionRegistrarNegocioScrenn());
      },
      child: Text(
        "Registrar negocio o servicio",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blueGrey, decoration: TextDecoration.underline),
      ),
    );
    /*return CustomButtom(
      textButton: "Registrar negocio o servicio",
      textColor: Colors.blueGrey,
      colorButton: Colors.white,
      callback: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => OpcionRegistrarNegocioScrenn()));
      },
    );*/
  }

  _showModal(bool visible){
    setState(() {
      _showProgress = visible;
    });
  }

  _showMessage({@required String body}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Alerta"),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar", style: TextStyle(color: Colors.green.shade600)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
}
