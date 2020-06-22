
import 'package:comunidad/bloc/sucursales_bloc.dart';
import 'package:comunidad/model/login_negocio_response.dart';
import 'package:comunidad/model/servicio_result.dart';
import 'package:comunidad/screen/admin/dash_board_productos_screen.dart';
import 'package:comunidad/tools/m_shared_preferences.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ListaSucursalesScreen extends StatefulWidget {
  @override
  _ListaSucursalesScreenState createState() => _ListaSucursalesScreenState();
}

class _ListaSucursalesScreenState extends State<ListaSucursalesScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool _showProgress = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    buscaSucursales();

  }

  buscaSucursales() async{
    LoginNegocioResponse negocioResponse = await MSharedPreferences.getUserNegocio();

    sucursalesBloc.sucursales(negocioResponse.result.object.objectId);
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
        title: Text("Sucursales", style: TextStyle(color: Colors.blueGrey)),
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
          child: Container(
            child: _listViewSucursales(),
          ),
        ),
      ),
    );
  }

  _listViewSucursales(){
    return StreamBuilder(
      stream: sucursalesBloc.observableSucursales,
      builder: (context, snapshot){
        if (snapshot.hasData){
          ServicioResult servicioResult = snapshot.data;
          List<Servicio> _listaServicios = servicioResult.result.object;
          if (_listaServicios != null && _listaServicios.length > 0){
            return ListView.builder(
              itemCount: _listaServicios.length,
              itemBuilder: (context, index){
                var servicio = _listaServicios[index];
                return Container(
                  height: 100,
                  child: Card(
                    elevation: 10,
                    child: Center(
                      child: ListTile(
                        trailing: Icon(Icons.store, color: Colors.green.shade600),
                        title: Text(servicio.nombre, style: TextStyle(color: Colors.blueGrey)),
                        subtitle: Text(servicio.direccion, style: TextStyle(color: Colors.grey)),
                        onTap: (){
                          MiniTools.nextScreen(context, DashBoardProductosScreen(servicio));
                        },
                      ),
                    ),
                  ),
                );
              }
            );
          }else{
            return Center(child: Text("Agrega una sucursal"));
          }
        }else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
