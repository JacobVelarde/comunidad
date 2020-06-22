
import 'package:comunidad/model/login_negocio_response.dart';
import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/provider/api_provider.dart';

class NegociosRepository{

  final apiProvider = ApiProvider();

  Future<LoginNegocioResponse> loginNegocio(String telefono, String password){
    return apiProvider.loginNegocio(telefono, password);
  }

  Future<ServerResult> createNegocio(String titular, String telefono, String nombreNegocio, String password){
    return apiProvider.createNegocio(titular, telefono, nombreNegocio, password);
  }
}