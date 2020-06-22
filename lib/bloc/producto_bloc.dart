
import 'package:comunidad/model/productos_servicio_response.dart';
import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/repository/producto_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductoBloc{

  final _repository = ProductoRepository();
  final _publishSubjectServerResult = PublishSubject<ServerResult>();
  final _publishSbuejctProductoServicioResponse = PublishSubject<ProductosServicioResponse>();

  Observable<ServerResult> get observableServerResult => _publishSubjectServerResult.stream;
  Observable<ProductosServicioResponse> get observableProductosServicioResponse => _publishSbuejctProductoServicioResponse.stream;

  createProducto(
      String idServicio,
      String nombre,
      String precio,
      String image64,
      String descripcion) async {

    ServerResult serverResult = await _repository.createProducto(idServicio, nombre, precio, image64, descripcion);
    _publishSubjectServerResult.sink.add(serverResult);
  }

  productosIdServicio(String idServicio) async{
    ProductosServicioResponse productosServicioResponse = await _repository.productoIdServicio(idServicio);
    _publishSbuejctProductoServicioResponse.sink.add(productosServicioResponse);
  }

  deleteProducto(String idProducto) async{
    ServerResult serverResult = await _repository.deleteProducto(idProducto);
    _publishSubjectServerResult.sink.add(serverResult);
  }

  dispose(){
    _publishSubjectServerResult.close();
    _publishSbuejctProductoServicioResponse.close();
  }
}

final productoBloc = ProductoBloc();