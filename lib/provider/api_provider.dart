
import 'dart:convert';

import 'package:comunidad/mixin/mixin_header.dart';
import 'package:comunidad/model/login_negocio_response.dart';
import 'package:comunidad/model/municipio_result.dart';
import 'package:comunidad/model/productos_servicio_response.dart';
import 'package:comunidad/model/server_result.dart';
import 'package:comunidad/model/servicio.dart' as custom;
import 'package:comunidad/model/servicio_result.dart';

import 'package:http/http.dart' as http;

class ApiProvider with Headers {

  Future<ServerResult> createServicio(custom.Servicio servicio) async{

    final client = http.Client();
    final response = await client.post(
        "https://parseapi.back4app.com/functions/createServicio",
        headers: parseHeaders,
        body: custom.servicioToJson(servicio)
    );

    if (response.statusCode == 200){
      return serverResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ServicioResult> servicios(String idMunicipio) async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/servicios",
      headers: parseHeaders,
      body: jsonEncode({"idMunicipio":idMunicipio})
    );

    if (response.statusCode == 200){
      return servicioResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<MunicipioResult> municipios() async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/municipio",
      headers: parseHeaders,
    );

    if (response.statusCode == 200){
      return municipioResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ServerResult> updateScore(String idServicio) async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/updateScore",
      headers: parseHeaders,
      body: jsonEncode({"idServicio":idServicio})
    );

    if (response.statusCode == 200){
      return serverResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ServerResult> versionApp(String versionApp) async{
    final client = http.Client();
    final response = await client.post(
        "https://parseapi.back4app.com/functions/versionApp",
        headers: parseHeaders,
        body: jsonEncode({"version":versionApp})
    );

    if (response.statusCode == 200){
      return serverResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<LoginNegocioResponse> loginNegocio(String telefono, String password) async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/loginNegocio",
      headers: parseHeaders,
      body: jsonEncode({"telefono":telefono, "password":password})
    );

    if (response.statusCode == 200){
      return loginNegocioResponseFromJson(response.body);
    }else{
      return null;
    }
  }
  
  Future<ServerResult> createNegocio(String titular, String telefono, String nombreNegocio, String password) async{
    final cliente = http.Client();
    final response = await cliente.post(
      "https://parseapi.back4app.com/functions/createNegocio",
      headers: parseHeaders,
      body: jsonEncode({"titular":titular, "telefono":telefono, "nombreNegocio":nombreNegocio, "password":password})
    );

    if (response.statusCode == 200){
      return serverResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ServerResult> createProducto(String idServicio, String nombre, String precio, String image64, String descripcion) async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/createProducto",
      headers: parseHeaders,
      body: jsonEncode({"idServicio":idServicio, "nombre":nombre, "precio":precio, "image64":image64, "descripcion": descripcion})
    );

    if (response.statusCode == 200){
      return serverResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ServicioResult> sucursales(String idNegocio) async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/servicioIdNegocio",
      headers: parseHeaders,
      body: jsonEncode({"idNegocio":idNegocio})
    );

    if (response.statusCode == 200){
      return servicioResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ServerResult> deleteProducto(String idProducto) async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/deleteProducto",
      headers: parseHeaders,
      body: jsonEncode({"idProducto":idProducto})
    );

    if (response.statusCode == 200){
      return serverResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ProductosServicioResponse> productosIdServicio(String idServicio) async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/productoIdServicio",
      headers: parseHeaders,
      body: jsonEncode({"idServicio": idServicio})
    );

    if (response.statusCode == 200){
      return productosServicioResponseFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ServicioResult> topServicios() async{
    final client = http.Client();
    final response = await client.post(
        "https://parseapi.back4app.com/functions/topServicios",
        headers: parseHeaders,
    );

    if (response.statusCode == 200){
      return servicioResultFromJson(response.body);
    }else{
      return null;
    }
  }

  Future<ServerResult> deleteServicio(String idServicio) async{
    final client = http.Client();
    final response = await client.post(
      "https://parseapi.back4app.com/functions/deleteServicio",
      headers: parseHeaders,
      body: jsonEncode({"idServicio": idServicio})
    );

    if (response.statusCode == 200){
      return serverResultFromJson(response.body);
    }else{
      return null;
    }
  }


}