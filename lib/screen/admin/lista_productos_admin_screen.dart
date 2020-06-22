
import 'package:auto_size_text/auto_size_text.dart';
import 'package:comunidad/bloc/producto_bloc.dart';
import 'package:comunidad/model/productos_servicio_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dash_board_sucursales_screen.dart';

class ListaProductosAdminScreen extends StatefulWidget {

  String idServicio;

  ListaProductosAdminScreen(this.idServicio);

  @override
  _ListaProductosAdminScreenState createState() => _ListaProductosAdminScreenState(idServicio);
}

class _ListaProductosAdminScreenState extends State<ListaProductosAdminScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String idServicio;
  bool _showProgress = false;

  _ListaProductosAdminScreenState(this.idServicio);

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    _initBloc();
  }

  _initBloc(){
    productoBloc.observableServerResult.listen((event) {
      _showModal(false);
      if (event != null){
        if (event.result.code == 200){
          Navigator.of(context).pop();
        }else{
          _showAlert(event.result.mensaje);
        }
      }
    });

    productoBloc.productosIdServicio(idServicio);

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
        title: Text("Lista de productos", style: TextStyle(color: Colors.blueGrey)),
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
          child: _listaProductos(),
        ),
      ),
    );
  }

  _listaProductos(){
    return StreamBuilder(
        stream: productoBloc.observableProductosServicioResponse,
        builder: (context, snapshot){
          if (snapshot.hasData){
            ProductosServicioResponse productosServicioResponse = snapshot.data;
            if (productosServicioResponse.result.object.length > 0){
              return ListView.builder(
                  itemCount: productosServicioResponse.result.object.length,
                  itemBuilder: (context, index){
                    var producto = productosServicioResponse.result.object[index];
                    print(producto.image64.url);
                    return LimitedBox(
                      maxHeight: 400,
                      child: GestureDetector(
                        onTap: (){
                          _showMessage(body: producto.nombre, idProducto: producto.objectId);
                        },
                        child: Card(
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 10),
                              Container(
                                /*decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red[500],
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),*/
                                height: 150,
                                width: 100,
                                child: Image.network(producto.image64.url),
                              ),
                              SizedBox(width: 10),
                              AutoSizeText(
                                  producto.nombre,
                                  maxLines: 3,
                                  style:
                                  TextStyle(
                                      fontSize: 30,
                                      color: Colors.green.shade600
                                  )
                              ),
                              AutoSizeText(
                                  "\$ "+producto.precio,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.blueGrey
                                  )
                              ),
                              AutoSizeText(
                                  producto.descripcion,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.grey
                                  )
                              ),
                              AutoSizeText(
                                "Eliminar producto",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.red
                                ),
                              )
                              /*Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                ],
                              )*/
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            }else{
              return Center(child: Text("Agrega al menos un producto"));
            }

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  _showMessage({@required String body, @required String idProducto}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("¿Quieres eliminar el producto?"),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar", style: TextStyle(color: Colors.green.shade600)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showModal(true);
                  productoBloc.deleteProducto(idProducto);
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

  _showAlert(String body) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(body),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar", style: TextStyle(color: Colors.red.shade600)),
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
