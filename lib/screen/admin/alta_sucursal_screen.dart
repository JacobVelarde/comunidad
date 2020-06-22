
import 'dart:async';

import 'package:comunidad/bloc/municipio_bloc.dart';
import 'package:comunidad/bloc/servicio_bloc.dart';
import 'package:comunidad/mixin/validaciones.dart';
import 'package:comunidad/model/login_negocio_response.dart';
import 'package:comunidad/model/municipio_result.dart';
import 'package:comunidad/model/servicio.dart';
import 'package:comunidad/screen/genericas/map_screen.dart';
import 'package:comunidad/tools/m_shared_preferences.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:comunidad/widgets/custom_button.dart';
import 'package:comunidad/widgets/custom_edit_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AltaSucursalScreen extends StatefulWidget {
  @override
  _AltaSucursalScreenState createState() => _AltaSucursalScreenState();
}

class _AltaSucursalScreenState extends State<AltaSucursalScreen> with Validaciones {

  TextEditingController _textNombreNegocio;
  TextEditingController _textDireccion;
  TextEditingController _textTelefono;
  TextEditingController _textDescripcion;

  final _globalKey = GlobalKey<FormState>();

  bool _showProgress = false;

  Municipio municipioSelected = null;

  @override
  void initState() {
    super.initState();

    _textNombreNegocio = TextEditingController();
    _textDireccion = TextEditingController();
    _textTelefono = TextEditingController();
    _textDescripcion = TextEditingController();

    //observableCreateService();
    municipioBloc.getMunicipios();
  }

  observableCreateService() {
    servicioBloc.observableCreateServerResult.listen((event) {
      if (event.result != null) {
        if (event.result.mensaje != null) {
          _showModal(false);
          _textTelefono.clear();
          _textDireccion.clear();
          _textNombreNegocio.clear();
          _textDescripcion.clear();
          _showMessage(body: event.result.mensaje);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alta sucursal", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
        ),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
          backgroundColor: Colors.white30,
        ),
        color: Colors.black,
        inAsyncCall: _showProgress,
        child: Form(
          key: _globalKey,
          child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 30),
                      _reusableText("Nombre de tu negocio o servicio:"),
                      _editTextNombre(),
                      _reusableText("Municipio:"),
                      _editTextMunicipio(),
                      SizedBox(height: 10),
                      _reusableText("Dirección:"),
                      _editTextDireccion(),
                      _reusableText("Telefono de contacto:"),
                      _editTextTelefono(),
                      _reusableText("Agrega una descripción de tu negocio o servicio"),
                      _editTextDescripcion(),
                      _buttomSubmit(),
                      SizedBox(height: 30),
                      //_reusableText("Sube una imagen para tu tarjeta en la lista de negocios o servicios:")
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }

  _reusableText(String titulo) {
    return Text(titulo,
      style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15
      ),
    );
  }

  _editTextNombre() {
    return CustomEditText(
      validator: validaNombre,
      controller: _textNombreNegocio,
      hiddenText: "Nombre del negocio o servicio",
      maxLength: 40,
    );
  }

  _editTextMunicipio() {
    return StreamBuilder(
        stream: municipioBloc.observableMunicipios,
        builder: (context, snapshot){
          if (snapshot.hasData){
            MunicipioResult municipioResult = snapshot.data;
            //Municipio valueSelected = municipioResult.result.object[0];
            return DropdownButton<Municipio>(
              hint: Text("Selecciona un municipio"),
              icon: Icon(Icons.arrow_drop_down_circle, color: Colors.green.shade600),
              underline: Container(
                height: 2,
                color: Colors.grey,
              ),
              isExpanded: true,
              value: municipioSelected,
              items: municipioResult.result.object.map<DropdownMenuItem<Municipio>>((value) {
                return DropdownMenuItem<Municipio>(
                  value: value,
                  child: Text(value.nombre),
                );
              }).toList(),
              onChanged: (Municipio m) {
                setState(() {
                  municipioSelected = m;
                });
              },
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  _editTextDireccion() {
    return CustomEditText(
      validator: validaDireccion,
      controller: _textDireccion,
      hiddenText: "Dirección del negocio o servicio",
      maxLength: 60,
    );
  }

  _editTextTelefono() {
    return CustomEditText(
      validator: validaTelefono,
      controller: _textTelefono,
      hiddenText: "Telefono de contacto",
      maxLength: 10,
      textInputType: TextInputType.number,
    );
  }

  _editTextDescripcion(){
    return CustomEditText(
      validator: validaDescripcion,
      controller: _textDescripcion,
      hiddenText: "Descripción",
      maxLength: 200,
    );
  }

  _buttomSubmit() {
    return CustomButtom(
      textButton: "Continuar",
      colorButton: Colors.green.shade600,
      callback: () async{
        if (_globalKey.currentState.validate()) {
          if (municipioSelected != null){
            MiniTools.hideKeyBoard(context);
           /* _showModal(true);
            LoginNegocioResponse negocioResponse = await MSharedPreferences.getUserNegocio();
            servicioBloc.createServicio(
                Servicio(
                    nombre: _textNombreNegocio.text,
                    direccion: _textDireccion.text,
                    telefonoContacto: _textTelefono.text,
                    idMunicipio: municipioSelected.objectId,
                    idNegocio: negocioResponse.result.object.objectId,
                    tieneCatalogo: true,
                    descripcion: _textDescripcion.text
                )
            );*/
            LoginNegocioResponse negocioResponse = await MSharedPreferences.getUserNegocio();
            MiniTools.nextScreen(context, MapScreen(servicio: Servicio(
               nombre: _textNombreNegocio.text,
               direccion: _textDireccion.text,
               telefonoContacto: _textTelefono.text,
               idMunicipio: municipioSelected.objectId,
               idNegocio: negocioResponse.result.object.objectId,
               tieneCatalogo: true,
               descripcion: _textDescripcion.text
           )));
          }else{
            _showMessage(body: "Selecciona un municipio");
          }
        }
      },
    );
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
