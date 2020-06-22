
import 'package:comunidad/model/login_negocio_response.dart';
import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/repository/negocios_repository.dart';
import 'package:rxdart/rxdart.dart';

class NegociosBloc{

  final _repository = NegociosRepository();
  final _publishSubjecServerResult = PublishSubject<ServerResult>();
  final _publishLoginNegocioResult = PublishSubject<LoginNegocioResponse>();

  Observable<ServerResult> get observableServerResult => _publishSubjecServerResult.stream;
  Observable<LoginNegocioResponse> get observableLoginNegocioResponse => _publishLoginNegocioResult.stream;

  login(String telefono, String password) async{
    LoginNegocioResponse loginNegocioResponse = await _repository.loginNegocio(telefono, password);
    _publishLoginNegocioResult.sink.add(loginNegocioResponse);
  }

  create(String titular, String telefono, String nombreNegocio, String password) async{
    ServerResult serverResult = await _repository.createNegocio(titular, telefono, nombreNegocio, password);
      _publishSubjecServerResult.sink.add(serverResult);
  }

  dispose(){
    _publishLoginNegocioResult.close();
    _publishSubjecServerResult.close();
  }
}

final negociosBloc = NegociosBloc();