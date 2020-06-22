
import 'package:comunidad/screen/admin/alta_sucursal_screen.dart';
import 'package:comunidad/screen/admin/lista_sucursales_screen.dart';
import 'package:comunidad/tools/mini_tools.dart';
import 'package:flutter/material.dart';

class DashBoardSucursalesScreen extends StatefulWidget {
  @override
  _DashBoardSucursalesScreenState createState() => _DashBoardSucursalesScreenState();
}

class _DashBoardSucursalesScreenState extends State<DashBoardSucursalesScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

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
      appBar: AppBar(
        title: Text("Panel de adminstración", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
        ),
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _cardAgregaSucursal(),
              _cardSucursalesActivas()
            ],
          ),
        ),
      ),
    );
  }

  _cardAgregaSucursal(){
    return Card(
      child: Container(
        height: 150,
        child: ListTile(
          title: Icon(Icons.add, size: 100, color: Colors.blue.shade600),
          subtitle: Text("Agrega una sucursal", textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
          onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AltaSucursalScreen()));
          },
        ),
      ),
    );
  }

  _cardSucursalesActivas(){
    return Card(
      child: Container(
        height: 150,
        child: ListTile(
          title: Icon(Icons.store, size: 100, color: Colors.green.shade600),
          subtitle: Text("Lista de sucursales", textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
          onTap: (){
            MiniTools.nextScreen(context, ListaSucursalesScreen());
          },
        ),
      ),
    );
  }
}
