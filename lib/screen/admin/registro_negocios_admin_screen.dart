
import 'package:comunidad/bloc/negocios_bloc.dart';
import 'package:comunidad/mixin/validaciones.dart';
import 'package:comunidad/widgets/custom_button.dart';
import 'package:comunidad/widgets/custom_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistroNegociosScreen extends StatefulWidget {
  @override
  _RegistroNegociosScreenState createState() => _RegistroNegociosScreenState();
}

class _RegistroNegociosScreenState extends State<RegistroNegociosScreen> with Validaciones {

  TextEditingController _textTelefonoController;
  TextEditingController _textNombreTitularController;
  TextEditingController _textNombreNegocioController;
  TextEditingController _textPasswordController;
  TextEditingController _textConfirmarPassword;

  bool _showProgress = false;

  final _globalKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    _textTelefonoController = TextEditingController();
    _textNombreNegocioController = TextEditingController();
    _textNombreTitularController = TextEditingController();
    _textPasswordController = TextEditingController();
    _textConfirmarPassword = TextEditingController();

    _initObservableNegocio();
  }

  @override
  void dispose() {
    super.dispose();

  }

  _initObservableNegocio(){
    negociosBloc.observableServerResult.listen((event) {
      _showModal(false);
      if (event != null){
        _showMessage(body: event.result.mensaje);
        _textNombreTitularController.clear();
        _textTelefonoController.clear();
        _textNombreNegocioController.clear();
        _textPasswordController.clear();
        _textConfirmarPassword.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de negocio", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _globalKey,
          child: ModalProgressHUD(
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
              backgroundColor: Colors.white30,
            ),
            color: Colors.black,
            inAsyncCall: _showProgress,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text("Nombre del titular de la cuenta", style: TextStyle(color: Colors.blueGrey)),
                      SizedBox(height: 10),
                      _textNombreTitular(),
                      SizedBox(height: 10),
                      Text("Telefono del titular de la cuenta", style: TextStyle(color: Colors.blueGrey)),
                      SizedBox(height: 10),
                      _textTelefonoTitular(),
                      SizedBox(height: 10),
                      Text("Nombre del negocio", style: TextStyle(color: Colors.blueGrey)),
                      SizedBox(height: 10),
                      _textNombreNegocio(),
                      Text("Contraseña", style: TextStyle(color: Colors.blueGrey)),
                      SizedBox(height: 10),
                      _textContrasenia(),
                      SizedBox(height: 10),
                      Text("Confirmar contraseaña", style: TextStyle(color: Colors.blueGrey)),
                      SizedBox(height: 10),
                      _textConfirmarContrasenia(),
                      SizedBox(height: 10),
                      _buttonRegistrar()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _textNombreTitular(){
    return CustomEditText(
      validator: validaNombre,
      hiddenText: "Nombre Completo",
      controller: _textNombreTitularController,
      maxLength: 100,
    );
  }

  _textTelefonoTitular(){
    return CustomEditText(
      validator: validaTelefono,
      hiddenText: "Telefono",
      maxLength: 10,
      controller: _textTelefonoController,
    );
  }

  _textNombreNegocio(){
    return CustomEditText(
      validator: validaNombre,
      hiddenText: "Nombre del negocio",
      maxLength: 100,
      controller: _textNombreNegocioController,
    );
  }

  _textContrasenia(){
    return CustomEditText(
      hiddenText: "Contraseña",
      maxLength: 20,
      validator: validaPasswod,
      controller: _textPasswordController,
    );
  }

  _textConfirmarContrasenia(){
    return CustomEditText(
      hiddenText: "Confirmar contraseña",
      maxLength: 20,
      controller: _textConfirmarPassword,
    );
  }

  _buttonRegistrar(){
    return CustomButtom(
      textButton: "Registrarme",
      callback: (){

        if (_globalKey.currentState.validate()) {
          if (_textPasswordController.text.compareTo(_textConfirmarPassword.text) == 0){
            _showModal(true);
            negociosBloc.create(_textNombreTitularController.text,
                _textTelefonoController.text,
                _textNombreNegocioController.text,
                _textPasswordController.text);
          }else{
            _showMessage(body: "Las contraseñas no coinciden, verifica e intenta nuevamente");
          }
        }
      },
    );
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
