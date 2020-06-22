// To parse this JSON data, do
//
//     final productosServicioResponse = productosServicioResponseFromJson(jsonString);

import 'dart:convert';

ProductosServicioResponse productosServicioResponseFromJson(String str) => ProductosServicioResponse.fromJson(json.decode(str));

String productosServicioResponseToJson(ProductosServicioResponse data) => json.encode(data.toJson());

class ProductosServicioResponse {
  Result result;

  ProductosServicioResponse({
    this.result,
  });

  factory ProductosServicioResponse.fromJson(Map<String, dynamic> json) => ProductosServicioResponse(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class Result {
  String mensaje;
  int code;
  List<Object> object;

  Result({
    this.mensaje,
    this.code,
    this.object,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    mensaje: json["mensaje"],
    code: json["code"],
    object: json["object"] != null ? List<Object>.from(json["object"].map((x) => Object.fromJson(x))) : List(),
  );

  Map<String, dynamic> toJson() => {
    "mensaje": mensaje,
    "code": code,
    "object": List<dynamic>.from(object.map((x) => x.toJson())),
  };
}

class Object {
  String idServicio;
  String nombre;
  String precio;
  String descripcion;
  Image64 image64;
  DateTime createdAt;
  DateTime updatedAt;
  String objectId;
  String type;
  String className;

  Object({
    this.idServicio,
    this.nombre,
    this.precio,
    this.descripcion,
    this.image64,
    this.createdAt,
    this.updatedAt,
    this.objectId,
    this.type,
    this.className,
  });

  factory Object.fromJson(Map<String, dynamic> json) => Object(
    idServicio: json["idServicio"],
    nombre: json["nombre"],
    precio: json["precio"],
    descripcion: json["descripcion"],
    image64: Image64.fromJson(json["image64"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    objectId: json["objectId"],
    type: json["__type"],
    className: json["className"],
  );

  Map<String, dynamic> toJson() => {
    "idServicio": idServicio,
    "nombre": nombre,
    "precio": precio,
    "descripcion": descripcion,
    "image64": image64.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "objectId": objectId,
    "__type": type,
    "className": className,
  };
}

class Image64 {
  String type;
  String name;
  String url;

  Image64({
    this.type,
    this.name,
    this.url,
  });

  factory Image64.fromJson(Map<String, dynamic> json) => Image64(
    type: json["__type"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "__type": type,
    "name": name,
    "url": url,
  };
}
