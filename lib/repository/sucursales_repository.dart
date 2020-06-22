

import 'package:comunidad/model/servicio_result.dart';
import 'package:comunidad/provider/api_provider.dart';

class SucursalesRepository{

  final apiProvider = ApiProvider();

  Future<ServicioResult> sucursales(String idNegocio){
    return apiProvider.sucursales(idNegocio);
  }

}