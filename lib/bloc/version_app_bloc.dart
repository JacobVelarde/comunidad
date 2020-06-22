
import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/repository/version_repository.dart';
import 'package:rxdart/rxdart.dart';

class VersionAppBloc{

  final _repository = VersionRepository();
  final _publishSubjectVersionApp = PublishSubject<ServerResult>();

  Observable<ServerResult> get observableVersionApp => _publishSubjectVersionApp.stream;

  versionApp(String versionApp) async{
    ServerResult serverResult = await _repository.versionApp(versionApp);
    _publishSubjectVersionApp.sink.add(serverResult);
  }

  dispose(){
    _publishSubjectVersionApp.close();
  }

}

final versionAppBloc = VersionAppBloc();