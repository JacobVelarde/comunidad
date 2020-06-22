
import 'dart:convert';
import 'dart:io';

import 'package:comunidad/bloc/producto_bloc.dart';
import 'package:comunidad/mixin/validaciones.dart';
import 'package:comunidad/model/login_negocio_response.dart';
import 'package:comunidad/tools/m_shared_preferences.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:comunidad/widgets/custom_button.dart';
import 'package:comunidad/widgets/custom_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AltaProductoScreen extends StatefulWidget {
  String idServicio;

  AltaProductoScreen(this.idServicio);

  @override
  _AltaProductoScreenState createState() => _AltaProductoScreenState(idServicio);
}

class _AltaProductoScreenState extends State<AltaProductoScreen> with Validaciones {

  String idServicio;

  _AltaProductoScreenState(this.idServicio);

  final _globalKey = GlobalKey<FormState>();
  bool _showProgress = false;

  File _imageSelected;

  TextEditingController _textControllerNombre;
  TextEditingController _textControllerPrecio;
  TextEditingController _textControllerDescripcion;
  LoginNegocioResponse _loginNegocioResponse;

  @override
  void initState() {
    super.initState();

    _textControllerNombre = TextEditingController();
    _textControllerPrecio = TextEditingController();
    _textControllerDescripcion = TextEditingController();

    initUsuario();
    initBloc();

  }

  initUsuario() async{
    _loginNegocioResponse = await MSharedPreferences.getUserNegocio();
  }

  initBloc(){
    productoBloc.observableServerResult.listen((event) {
      _showModal(false);
      if (event != null){
        _textControllerDescripcion.clear();
        _textControllerPrecio.clear();
        _textControllerNombre.clear();
        _showMessage(body: event.result.mensaje);
      }else{
        _showMessage(body: "Verifica tu conexión a internet");
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
        title: Text("Agrega producto", style: TextStyle(color: Colors.blueGrey)),
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
          child: Form(
            key: _globalKey,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 10),
                      _contenedorimage(),
                      SizedBox(height: 10),
                      _optionsButtonsGaleryCamera(),
                      SizedBox(height: 10),
                      _reusableText("Nombre del producto"),
                      _editTextNombre(),
                      _reusableText("Precio del producto"),
                      _editTextPrecio(),
                      _reusableText("Descripción del producto"),
                      _editTextDescripcion(),
                      _buttonGuardarProducto()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _contenedorimage(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 100,
      child: _imageSelected == null ?
        Text("Carga una imagen de la galeria o directamente de la camara",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),) :
        Image.file(_imageSelected)
    );
  }

  _optionsButtonsGaleryCamera(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomButtom(
          colorButton: Colors.white,
          textColor: Colors.green.shade600,
          textButton: "Abrir camara",
          callback: (){
              getImageFrom(ImageSource.camera);
          },
        ),
        CustomButtom(
          colorButton: Colors.white,
          textColor: Colors.green.shade600,
          textButton: "Abrir galeria",
          callback: (){
            getImageFrom(ImageSource.gallery);
          },
        )
      ],
    );
  }

  _reusableText(String text){
    return Text(text, style: TextStyle(color: Colors.blueGrey));
  }

  _editTextNombre(){
    return CustomEditText(
      hiddenText: "Nombre del producto",
      maxLength: 100,
      controller: _textControllerNombre,
      validator: validaNombre,
    );
  }

  _editTextPrecio(){
    return CustomEditText(
      hiddenText: "Precio del producto",
      maxLength: 100,
      controller: _textControllerPrecio,
      validator: validaPrecio,
      textInputType: TextInputType.number,
    );
  }

  _editTextDescripcion(){
    return CustomEditText(
      hiddenText: "Descripción del producto",
      maxLength: 500,
      controller: _textControllerDescripcion,
      validator: validaDescripcion,
    );
  }

  _buttonGuardarProducto(){
    return CustomButtom(
      textButton: "Guardar",
      callback: () async{
        if (_globalKey.currentState.validate()){
          MiniTools.hideKeyBoard(context);
          if (_imageSelected == null){
            _showMessage(body: "Agrega una imagen a tu producto");
          }else if (_loginNegocioResponse == null){
            _showMessage(body: "Intenta hacer login nuevamente");
          }else{

            final imageBytes = _imageSelected.readAsBytesSync();
            String img64 = base64Encode(imageBytes);

            if (img64 == null || img64.length == 0){
              _showMessage(body: "Intenta cargar otra imagen");
            }else{
              _showModal(true);
              productoBloc.createProducto(
                  idServicio,
                  _textControllerNombre.text,
                  _textControllerPrecio.text,
                  img64,
                  _textControllerDescripcion.text);
            }
          }
        }
      },
    );
  }

  Future getImageFrom(ImageSource imageSource) async{
    var image = await ImagePicker.pickImage(
        source: imageSource,
        imageQuality: 30
    );
    setState(() {
      _imageSelected = image;
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
                  setState(() {
                    _imageSelected = null;
                  });
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
