
import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/provider/api_provider.dart';

class VersionRepository{
  final apiProvider = ApiProvider();

  Future<ServerResult> versionApp(String versionApp){
    return apiProvider.versionApp(versionApp);
  }

}