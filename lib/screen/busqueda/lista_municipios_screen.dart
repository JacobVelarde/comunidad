
import 'package:comunidad/bloc/municipio_bloc.dart';
import 'package:comunidad/model/municipio_result.dart';
import 'package:comunidad/screen/busqueda/lista_negocios_screen.dart';
import 'package:flutter/material.dart';

class ListaMunicipiosScreen extends StatefulWidget {
  @override
  _ListaMunicipiosScreenState createState() => _ListaMunicipiosScreenState();
}

class _ListaMunicipiosScreenState extends State<ListaMunicipiosScreen> {

  GlobalKey<RefreshIndicatorState> _refreshKey;
  List<Municipio> _listaMunicipios;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshKey = GlobalKey<RefreshIndicatorState>();
    _listaMunicipios = List();
    _cargaMunicipios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("¿Donde?", style: TextStyle(color: Colors.blueGrey)),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          child: _listViewMunicipios()
        )
      ),
    );
  }

  _listViewMunicipios(){


    if (_listaMunicipios.length == 0){
      return Center(child: CircularProgressIndicator());
    }else{
      return ListView.builder(
          itemCount: _listaMunicipios.length,
          itemBuilder: (BuildContext context, int index) {
            var municipio = _listaMunicipios[index];
            return Container(
                height: 70,
                child:  Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text(municipio.nombre, style: TextStyle(color: Colors.black)),
                      trailing: Icon(Icons.arrow_forward, color: Colors.green,),
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ListaNegociosScreen(municipio.objectId)));
                      },
                    )
                )
            );
          });
    }
  }

  _cargaMunicipios(){

    municipioBloc.observableMunicipios.listen((event) {
      if (event != null){
        if (event.result.object != null){
          if (event.result.object.length > 0){
            setState(() {
              _listaMunicipios.addAll(event.result.object);
            });
          }
        }
      }
    });

    municipioBloc.getMunicipios();
  }
}
