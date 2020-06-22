
import 'package:comunidad/bloc/negocios_bloc.dart';
import 'package:comunidad/screen/admin/dash_board_sucursales_screen.dart';
import 'package:comunidad/screen/admin/registro_negocios_admin_screen.dart';
import 'package:comunidad/tools/m_shared_preferences.dart';
import 'package:comunidad/widgets/custom_button.dart';
import 'package:comunidad/widgets/custom_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginNegociosScreen extends StatefulWidget {
  @override
  _LoginNegociosScreenState createState() => _LoginNegociosScreenState();
}

class _LoginNegociosScreenState extends State<LoginNegociosScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool _showProgress = false;

  TextEditingController _telefonoController;
  TextEditingController _passwordController;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    _telefonoController = TextEditingController();
    _passwordController = TextEditingController();

    _initLoginObserver();
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
        title: Text("Entrar", style: TextStyle(color: Colors.blueGrey)),
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
            margin: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("Iniciar sesión", style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 30),
                        textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    _editTextTelefono(),
                    SizedBox(height: 30),
                    _editTextPassword(),
                    SizedBox(height: 40),
                    _buttonLogin(),
                    SizedBox(height: 30),
                    GestureDetector(
                      child: Text("Registrarme",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                            color: Colors.blueGrey
                          ),
                          textAlign: TextAlign.center,
                      ),
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => RegistroNegociosScreen()));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _editTextTelefono(){
    return CustomEditText(
      hiddenText: "Telefono",
      controller: _telefonoController,
    );
  }

  _editTextPassword(){
    return CustomEditText(
      obscureText: true,
      textInputType: TextInputType.visiblePassword,
      hiddenText: "Contraseña",
      controller: _passwordController,
    );
  }

  _buttonLogin(){
    return CustomButtom(
      textButton: "Entrar",
      callback: (){

        if (_telefonoController.text != "" && _passwordController.text != ""){
          FocusScope.of(context).requestFocus(FocusNode());
          _showModal(true);
          negociosBloc.login(_telefonoController.text.trim(), _passwordController.text);
        }else{
          _showMessage(body: "Ingresa tu telefono y contraseña");
        }
      },
    );
  }

  _initLoginObserver(){
    negociosBloc.observableLoginNegocioResponse.listen((event) {
      _showModal(false);
      if (event != null){
        if (event.result.code == 200){

          MSharedPreferences.saveUserNegocio(event).then((value) => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DashBoardSucursalesScreen())));

        }else{
          _showMessage(body: event.result.mensaje);
        }
      }
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

  _showModal(bool visible){
    setState(() {
      _showProgress = visible;
    });
  }
}

