

import 'package:comunidad/model/municipio_result.dart';
import 'package:comunidad/provider/api_provider.dart';

class MunicipioRepository{

  final apiProvider = ApiProvider();

  Future<MunicipioResult>getMunicipios( ){
    return apiProvider.municipios();
  }
}