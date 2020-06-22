
import 'package:comunidad/model/municipio_result.dart';
import 'package:comunidad/repository/municipio_repository.dart';
import 'package:rxdart/rxdart.dart';

class MunicipioBloc{

  final _repository = MunicipioRepository();
  final _publicSubjectMunicipio = PublishSubject<MunicipioResult>();

  Observable<MunicipioResult> get observableMunicipios => _publicSubjectMunicipio.stream;

  getMunicipios() async{
    MunicipioResult municipioResult = await _repository.getMunicipios();
    _publicSubjectMunicipio.sink.add(municipioResult);
  }

  dispose(){
    _publicSubjectMunicipio.close();
  }

}

final municipioBloc = MunicipioBloc();