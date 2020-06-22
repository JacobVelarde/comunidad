
import 'package:comunidad/bloc/servicio_bloc.dart';
import 'package:comunidad/model/servicio_local.dart';
import 'package:comunidad/model/servicio_result.dart';
import 'package:comunidad/screen/busqueda/catalogo_producto_screen.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaNegociosScreen extends StatefulWidget {

  String _idMunicipio;
  ListaNegociosScreen(this._idMunicipio);

  @override
  _ListaNegociosScreenState createState() => _ListaNegociosScreenState(_idMunicipio);
}

class _ListaNegociosScreenState extends State<ListaNegociosScreen> {

  String idMunicipio;

  _ListaNegociosScreenState(this.idMunicipio);

  bool _showProgress = false;

  ServicioLocal _servicioLocal;

  @override
  void initState() {
    super.initState();
    servicioBloc.getAllServicios(idMunicipio);
    _buscarServiciosLocales();
  }

  _buscarServiciosLocales() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String listaLocal = preferences.getString("LISTA_LOCAL") ?? "";

    if (listaLocal.compareTo("") == 0){
      _servicioLocal = ServicioLocal();
    }else{
      _servicioLocal = servicioLocalFromJson(listaLocal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Anuncios", style: TextStyle(color: Colors.blueGrey)),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
          onTap: (){
            Navigator.pop(context);
          },
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
              child: _listViewServicios()
              ),
        )
      ),
    );
  }

  _listViewServicios(){
    return StreamBuilder(
      stream: servicioBloc.observableServicioResult,
      builder: (context, snapshot){
        if (snapshot.hasData){
          ServicioResult servicioResult = snapshot.data;
          List<Servicio> _listaServicios = servicioResult.result.object;
          if (_listaServicios != null && _listaServicios.length > 0){
            return ListView.builder(
                itemCount: _listaServicios.length,
                itemBuilder: (BuildContext context, int index) {
                  var servicio = _listaServicios[index];

                  bool puntajeLocal = _tienePuntajeLocal(servicio.objectId);

                  return GestureDetector(
                    onTap: (){
                      servicio.tieneCatalogo ?
                      MiniTools.nextScreen(context, CatalogoProductoScreen(servicio)) :
                      print("No tiene catálogo");
                    },
                    child: Container(
                        height: 200,
                        child:  Card(
                            margin: EdgeInsets.all(10),
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.store, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text(servicio.nombre, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Text("Ubicación:", style: TextStyle(color: Colors.grey)),
                                  Text(servicio.direccion, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                  Text("Teléfono:", style: TextStyle(color: Colors.grey)),
                                  Text(servicio.telefono, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                  Row(
                                    children: <Widget>[
                                      Text("¿Recomiendas este lugar?"),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        child: Icon(Icons.star, color: puntajeLocal ? Colors.amberAccent : Colors.grey),
                                        onTap: (){
                                          if (!puntajeLocal){
                                            _showModal(true);
                                            _enviaPuntuacion(servicio.objectId);
                                          }else{
                                            _showMessage(body: "Ya lo recomendaste");
                                          }
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      servicio.puntuacion != null ? Text("+" + servicio.puntuacion.toString()) : Text("")
                                    ],
                                  ),
                                  servicio.tieneCatalogo != null && servicio.tieneCatalogo ? Text("Ver catálogo", style: TextStyle(color: Colors.amber.shade600, fontWeight: FontWeight.bold, decoration: TextDecoration.underline), textAlign: TextAlign.right) : SizedBox(height: 0),
                                ],
                              ),
                            )
                        )
                    ),
                  );
                });
          }else{
            return Center(child: Text("No hay servicios o negocios disponibles"));
          }

        }else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );

  }

  _tienePuntajeLocal(String idServicio){
    if (_servicioLocal != null && _servicioLocal.servicio != null){
      if (_servicioLocal.servicio.length > 0){
        for(String idServicioLocal in _servicioLocal.servicio){
          if (idServicioLocal.compareTo(idServicio) == 0){
            return true;
          }
        }
      }
    }
    return false;
  }

  _enviaPuntuacion(String idServicio){

    servicioBloc.observableUpdateScore.listen((event) async{
      if (event != null){

        if (event.result.code == 200){
          SharedPreferences preferences = await SharedPreferences.getInstance();
          if (_servicioLocal.servicio == null){
            _servicioLocal.servicio = List();
          }
          _servicioLocal.servicio.add(idServicio);
          await preferences.setString("LISTA_LOCAL", servicioLocalToJson(_servicioLocal));
        }

        _showModal(false);
        _showMessage(body: event.result.mensaje);
      }
    });

    servicioBloc.updateScore(idServicio);
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
