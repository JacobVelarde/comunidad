
import 'package:comunidad/model/servicio_result.dart';
import 'package:comunidad/repository/sucursales_repository.dart';
import 'package:rxdart/rxdart.dart';

class SucursalesBloc{

  final _repository = SucursalesRepository();
  final _publicSubjectSucursales = PublishSubject<ServicioResult>();

  Observable<ServicioResult> get observableSucursales => _publicSubjectSucursales.stream;

  sucursales(String idNegocio) async{
    ServicioResult servicioResult = await _repository.sucursales(idNegocio);
    _publicSubjectSucursales.sink.add(servicioResult);
  }

  dispose(){
    _publicSubjectSucursales.close();
  }
}

final sucursalesBloc = SucursalesBloc();