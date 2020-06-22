import 'dart:async';

import 'package:comunidad/bloc/servicio_bloc.dart';
import 'package:comunidad/screen/admin/registro_completo_screen.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:comunidad/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:comunidad/model/servicio.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MapScreen extends StatefulWidget {

  String latitud, longitud;
  Servicio servicio;

  MapScreen({this.latitud, this.longitud, this.servicio});

  @override
  _MapScreenState createState() => _MapScreenState(servicio: servicio);
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String latitud, longitud;
  Servicio servicio;
  bool _showProgress = false;

  String textHeader = "Ubica tu negocio";

  Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  CameraPosition _myLocation;

  _MapScreenState({this.latitud, this.longitud, this.servicio});

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    if (latitud != null){
      _myLocation = CameraPosition(target: LatLng(double.parse(latitud), double.parse(longitud)));
      textHeader = "Ubicación";
    }else{
      _myLocation = CameraPosition(target: LatLng(0,0));
    }

    observableCreateService();
  }

  observableCreateService() {
    servicioBloc.observableCreateServerResult.listen((event) {
      if (event.result != null) {
        if (event.result.mensaje != null) {
          _showModal(false);
          //_showMessage(body: event.result.mensaje);
          MiniTools.nextScreen(context, RegistroCompletoScreen("Sucursal"));
        }
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
        title: Text(textHeader, style: TextStyle(color: Colors.blueGrey)),
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
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              _showGoogleMaps(),
              _buttonRegistrar(),
            ],
          ),
        )
      ),
    );
  }

  _buttonRegistrar(){
    if(latitud == null){
      return CustomButtom(
        textButton: "Registrar",
        colorButton: Colors.white,
        textColor: Colors.green,
        callback: (){
          if (_markers.length > 0){
            _showModal(true);
            servicio.latitud = _markers.first.position.latitude.toString();
            servicio.longitud = _markers.first.position.longitude.toString();
            servicioBloc.createServicio(servicio);
          }else{
            _showMessage(body: "Elige la ubicación de tu negocio");
          }
        },
      );
    }else{
      return SizedBox(height: 1);
    }
  }

  _showGoogleMaps() {
    return GoogleMap(
      initialCameraPosition: _myLocation,
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      onTap: _addMarker,
      markers: _markers,
      trafficEnabled: false,
    );
  }

  _addMarker(LatLng latLng) {
    setState(() {
      _markers.clear();
      final mMarker = Marker(
          markerId: MarkerId("destination"),
          position: latLng,
          infoWindow: InfoWindow(title: "Tu negocio"),
          icon: BitmapDescriptor.defaultMarker);
      _markers.add(mMarker);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
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

  _showModal(bool visible){
    setState(() {
      _showProgress = visible;
    });
  }
}
