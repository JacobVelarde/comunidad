
import 'package:auto_size_text/auto_size_text.dart';
import 'package:comunidad/bloc/servicio_bloc.dart';
import 'package:comunidad/bloc/sucursales_bloc.dart';
import 'package:comunidad/model/servicio_result.dart';
import 'package:comunidad/screen/admin/alta_producto_screen.dart';
import 'package:comunidad/screen/admin/lista_productos_admin_screen.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dash_board_sucursales_screen.dart';

class DashBoardProductosScreen extends StatefulWidget {
  Servicio servicio;

  DashBoardProductosScreen(this.servicio);

  @override
  _DashBoardProductosScreenState createState() => _DashBoardProductosScreenState(servicio);
}

class _DashBoardProductosScreenState extends State<DashBoardProductosScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Servicio _servicio;
  ServicioBloc _servicioBloc;
  bool _showProgress = false;

  _DashBoardProductosScreenState(this._servicio);

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _servicioBloc = ServicioBloc();
    super.initState();

    _listenServicioResult();
  }

  _listenServicioResult(){
    _servicioBloc.observableServerResult.listen((event) {
      if (event != null){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => DashBoardSucursalesScreen()),
          ModalRoute.withName('/'),
        );
      }
    });
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
        title: Text("Panel de productos", style: TextStyle(color: Colors.blueGrey)),
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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      AutoSizeText(_servicio.nombre,
                          textAlign: TextAlign.center,
                          minFontSize: 20,
                          maxFontSize: 30,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          )),
                      AutoSizeText(_servicio.direccion,
                          textAlign: TextAlign.center,
                          minFontSize: 20,
                          maxFontSize: 30,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.grey,
                          )
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _cardAddProducto(),
                    //_cardDeleteProducto(),
                    _cardListaProductos()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _cardEliminaSucursal(),
                    //_cardSoporte()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cardAgregaSucursal(){
    return Card(
      child: Container(
        height: 150,
          child: ListTile(
            title: Icon(Icons.store, size: 50, color: Colors.deepPurple.shade600),
            subtitle: Text("Agrega una sucursal", textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
          ),
      ),
    );
  }

  _cardAddProducto(){
    return Card(
      child: Container(
        height: 150,
        width: 150,
        child: ListTile(
          title: Icon(Icons.add, size: 100, color: Colors.green.shade600),
          subtitle: Text("Agrega un producto", textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
          onTap: () => MiniTools.nextScreen(context, AltaProductoScreen(_servicio.objectId)),
        ),
      ),
    );
  }

  _cardEliminaSucursal(){
    return Card(
      child: Container(
        height: 150,
        width: 150,
        child: ListTile(
          title: Icon(Icons.close, size: 100, color: Colors.red.shade600,),
          subtitle: Text("Eliminar esta sucursal", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          onTap: (){
            _showMessage(body: "Estas seguro de eliminar esta sucursal", idServicio: _servicio.objectId);
          },
        ),
      ),
    );
  }

  _cardListaProductos(){
    return Card(
      child: Container(
        height: 150,
        width: 150,
        child: ListTile(
          title: Icon(Icons.format_list_bulleted, size: 100, color: Colors.blue.shade600),
          subtitle: Text("Lista de productos", textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
          onTap: () => MiniTools.nextScreen(context, ListaProductosAdminScreen(_servicio.objectId)),
        ),
      ),
    );
  }

  _cardSoporte(){
    return Card(
      child: Container(
        height: 150,
        width: 150,
        child: ListTile(
          title: Icon(Icons.help_outline, size: 100, color: Colors.yellow.shade600),
          subtitle: Text("Ayuda", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  _showMessage({@required String body, @required String idServicio}) {
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
                  _showModal(true);
                  _servicioBloc.deleteServicio(idServicio);
                },
              ),
              FlatButton(
                child: Text("Cancelar", style: TextStyle(color: Colors.red.shade600)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  _showModal(bool visible){
    setState(() {
      _showProgress = visible;
    });
  }
}
