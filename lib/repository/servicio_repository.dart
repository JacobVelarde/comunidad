

import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/model/servicio.dart' as custom;
import 'package:comunidad/model/servicio_result.dart';
import 'package:comunidad/provider/api_provider.dart';

class ServicioRepository{

  final apiProvider = ApiProvider();

  Future<ServerResult> createServicio(custom.Servicio servicio){
    return apiProvider.createServicio(servicio);
  }

  Future<ServicioResult> servicios(String idMunicipio){
    return apiProvider.servicios(idMunicipio);
  }

  Future<ServerResult> updateScore(String idServicio){
    return apiProvider.updateScore(idServicio);
  }

  Future<ServicioResult> topServicios(){
    return apiProvider.topServicios();
  }

  Future<ServerResult> delete(String idServicio){
    return apiProvider.deleteServicio(idServicio);
  }

}