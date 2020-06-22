
import 'package:comunidad/model/productos_servicio_response.dart';
import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/provider/api_provider.dart';

class ProductoRepository {

  final apiProvider = ApiProvider();

  Future<ServerResult> createProducto(
      String idServicio,
      String nombre,
      String precio,
      String image64,
      String descripcion) async {

    return apiProvider.createProducto(
        idServicio, nombre, precio, image64, descripcion);
  }

  Future<ProductosServicioResponse> productoIdServicio(String idServicio) async{
    return apiProvider.productosIdServicio(idServicio);
  }

  Future<ServerResult> deleteProducto(String idProducto) async{
    return apiProvider.deleteProducto(idProducto);
  }
}