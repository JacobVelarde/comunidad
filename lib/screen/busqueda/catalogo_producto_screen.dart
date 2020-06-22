import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:comunidad/bloc/producto_bloc.dart';
import 'package:comunidad/model/productos_servicio_response.dart';
import 'package:comunidad/model/servicio_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CatalogoProductoScreen extends StatefulWidget {

  Servicio servicio;

  CatalogoProductoScreen(this.servicio);

  @override
  _CatalogoProductoScreenState createState() => _CatalogoProductoScreenState(servicio);
}

class _CatalogoProductoScreenState extends State<CatalogoProductoScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  Servicio servicio;
  _CatalogoProductoScreenState(this.servicio);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    final mMarker = Marker(
        markerId: MarkerId("destination"),
        position: LatLng(double.parse(servicio.latitud), double.parse(servicio.longitud)),
        infoWindow: InfoWindow(title: "Ubicación"),
        icon: BitmapDescriptor.defaultMarker);
    _markers.add(mMarker);

    initBloc();

  }

  initBloc(){
    productoBloc.productosIdServicio(servicio.objectId);
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
        backgroundColor: Colors.white,
        title: Text("Catálogo de productos", style: TextStyle(color: Colors.blueGrey)),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: _catalogo(),
      ),
    );
  }

  _header(List<Object> productos){
    List<Widget> productoBanners = getBanners(productos);
    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        autoPlayCurve: Curves.easeInOutQuart,
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: productoBanners,
    );
  }

  List<Widget> _bodyGrid(List<Object> productos){
    return productos.map((producto) =>
       GestureDetector(
         onTap: (){
          _muestraDetalleProducto(context, producto);
         },
         child: Card(
           child: ListTile(
             title: AutoSizeText(producto.nombre, minFontSize: 10, maxFontSize: 12, maxLines: 3, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
             subtitle: AutoSizeText(" \$ " + producto.precio + " ", minFontSize: 10, maxFontSize: 15, maxLines: 2, style: TextStyle(color: Colors.blueGrey)),
             leading: Container(
               width: 60,
               height: 90,
               child: ClipRRect(
                   borderRadius: BorderRadius.circular(50),
                   child: Image(
                     image: AdvancedNetworkImage(
                       producto.image64.url,
                       useDiskCache: true,
                       cacheRule: CacheRule(maxAge: const Duration(days: 1)),
                     ),
                     fit: BoxFit.cover,
                   )
               ),
             ),
           ),
         )
       )
    ).toList();
  }

  getBanners(List<Object> objects){
    return objects.map((producto) => GestureDetector(
      onTap: (){
        _muestraDetalleProducto(context, producto);
      },
      child: Card(
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Image.network(
              producto.image64.url,
          ),
        ),
      ),
    )
    ).toList();
  }

  _catalogo(){
    return StreamBuilder(
        stream: productoBloc.observableProductosServicioResponse,
        builder: (context, snapshot){
          if (snapshot.hasData){
            ProductosServicioResponse productosServicioResponse = snapshot.data;
            if (productosServicioResponse.result.object.length > 0){

              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 10),
                      AutoSizeText(servicio.nombre,
                          minFontSize: 20,
                          maxFontSize: 30,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 15),
                      //_header(productosServicioResponse.result.object),
                      //SizedBox(height: 10),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: AutoSizeText("Ubicación:",
                            minFontSize: 17,
                            maxFontSize: 17,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey)
                        ),
                      ),
                      _showGoogleMaps(),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: AutoSizeText("Catálogo:",
                            minFontSize: 17,
                            maxFontSize: 17,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey)
                        ),
                      ),
                      //_header(productosServicioResponse.result.object),
                      //SizedBox(height: 10),
                    ]),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2
                    ),
                    delegate: SliverChildListDelegate(
                      _bodyGrid(productosServicioResponse.result.object),
                    ),
                  )
                ],
              );
            }else{
              return Center(child: Text("No hay productos disponibles"));
            }

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  _muestraDetalleProducto(contex, Object producto){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
        ),
        context: context,
        builder: (BuildContext bc){
          return Container(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: 100,
                      height: 100,
                      child: Image.network(producto.image64.url),
                    ),
                    Column(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width - 120, height: 20),
                          child: AutoSizeText(
                              producto.nombre,
                              minFontSize: 12,
                              maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  //backgroundColor: Colors.redAccent
                              )
                          ),
                        ),
                        SizedBox(height: 30),
                        ConstrainedBox(
                          constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width - 120, height: 20),
                          child: AutoSizeText(
                              "\$ "+producto.precio,
                              minFontSize: 12,
                              maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width, height: 200),
                    child: AutoSizeText(
                        producto.descripcion,
                        minFontSize: 12,
                        maxFontSize: 20,
                        maxLines: 10,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _showGoogleMaps() {
    return servicio.latitud.compareTo("0") == 0 ? Padding(padding: EdgeInsets.only(left: 10),child: Text("Ubicación no disponible")) :
    Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 200,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(double.parse(servicio.latitud), double.parse(servicio.longitud)), zoom: 17),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          trafficEnabled: false,
          markers: _markers,
        ),
      ),
    );
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }
}
