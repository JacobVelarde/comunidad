

import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/model/servicio.dart' as custom;
import 'package:comunidad/model/servicio_result.dart';
import 'package:comunidad/repository/servicio_repository.dart';
import 'package:rxdart/rxdart.dart';

class ServicioBloc{

  final _repository = ServicioRepository();
  final _publicSubjectCreateServicio = PublishSubject<ServerResult>();
  final _publicSubjectServicios = PublishSubject<ServicioResult>();
  final _publicSubjectUpdateScore = PublishSubject<ServerResult>();

  //No crear mas serverresult
  final _publicServerResult = PublishSubject<ServerResult>();

  Observable<ServerResult> get observableCreateServerResult => _publicSubjectCreateServicio.stream;
  Observable<ServicioResult> get observableServicioResult => _publicSubjectServicios.stream;
  Observable<ServerResult> get observableUpdateScore => _publicSubjectUpdateScore.stream;

  Observable<ServerResult> get observableServerResult => _publicServerResult.stream;

  createServicio(custom.Servicio servicio) async{
    ServerResult serverResult = await _repository.createServicio(servicio);
    _publicSubjectCreateServicio.sink.add(serverResult);
  }

  getAllServicios(String idMunicipio) async{
    ServicioResult servicioResult = await _repository.servicios(idMunicipio);
    _publicSubjectServicios.sink.add(servicioResult);
  }

  updateScore(String idServicio) async{
    ServerResult serverResult = await _repository.updateScore(idServicio);
    _publicSubjectUpdateScore.sink.add(serverResult);
  }

  topServicios() async{
    ServicioResult servicioResult = await _repository.topServicios();
    _publicSubjectServicios.sink.add(servicioResult);
  }

  deleteServicio(String idServicio) async{
    ServerResult serverResult = await _repository.delete(idServicio);
    _publicServerResult.sink.add(serverResult);

  }

  dispose(){
    _publicSubjectCreateServicio.close();
    _publicSubjectServicios.close();
    _publicSubjectUpdateScore.close();
  }

}

final servicioBloc = ServicioBloc();