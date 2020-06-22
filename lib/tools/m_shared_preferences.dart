
import 'package:comunidad/model/login_negocio_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MSharedPreferences {

  static const String USER_NEGOCIO = "negocio_user";

  static Future saveUserNegocio(LoginNegocioResponse loginNegocioResponse) async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(USER_NEGOCIO, loginNegocioResponseToJson(loginNegocioResponse));
  }

  static Future<LoginNegocioResponse> getUserNegocio() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String jsonObject = _preferences.getString(USER_NEGOCIO) ?? "";
    if (jsonObject.compareTo("") == 0){
      return null;
    }else{
      return loginNegocioResponseFromJson(jsonObject);
    }
  }
}