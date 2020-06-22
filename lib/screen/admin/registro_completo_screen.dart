import 'package:comunidad/screen/admin/dash_board_sucursales_screen.dart';
import 'package:comunidad/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RegistroCompletoScreen extends StatefulWidget {

  String _tipoSolicitud;

  RegistroCompletoScreen(this._tipoSolicitud);

  @override
  _RegistroCompletoScreenState createState() => _RegistroCompletoScreenState(_tipoSolicitud);
}

class _RegistroCompletoScreenState extends State<RegistroCompletoScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String _tipoSolicitud;

  _RegistroCompletoScreenState(this._tipoSolicitud);

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(_tipoSolicitud, style: TextStyle(
                color: Colors.green.shade600,
                fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text("Guardado correctamente", style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 25),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            CustomButtom(
              textButton: "Continuar",
              colorButton: Colors.green.shade600,
              textColor: Colors.white,
              callback: (){
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => DashBoardSucursalesScreen()),
                  ModalRoute.withName('/'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
