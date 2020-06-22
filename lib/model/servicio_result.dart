
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ServicioResult servicioResultFromJson(String str) => ServicioResult.fromJson(json.decode(str));

String servicioResultToJson(ServicioResult data) => json.encode(data.toJson());

class ServicioResult {
  Result result;

  ServicioResult({
    this.result,
  });

  factory ServicioResult.fromJson(Map<String, dynamic> json) => ServicioResult(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class Result {
  String mensaje;
  int code;
  List<Servicio> object;

  Result({
    this.mensaje,
    this.code,
    this.object,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    mensaje: json["mensaje"],
    code: json["code"],
    object:json["object"] == null ? null : List<Servicio>.from(json["object"].map((x) => Servicio.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mensaje": mensaje,
    "code": code,
    "object": List<dynamic>.from(object.map((x) => x.toJson())),
  };
}

class Servicio {
  String nombre;
  String direccion;
  String telefono;
  String idMunicipio;
  DateTime createdAt;
  DateTime updatedAt;
  String objectId;
  String type;
  String className;
  int puntuacion;
  bool tieneCatalogo;
  String latitud;
  String longitud;

  Servicio({
    this.nombre,
    this.direccion,
    this.telefono,
    this.idMunicipio,
    this.createdAt,
    this.updatedAt,
    this.objectId,
    this.type,
    this.className,
    this.puntuacion,
    this.tieneCatalogo,
    this.latitud,
    this.longitud
  });

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
    nombre: json["nombre"],
    direccion: json["direccion"],
    telefono: json["telefono"],
    idMunicipio: json["idMunicipio"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    objectId: json["objectId"],
    type: json["__type"],
    className: json["className"],
    puntuacion: json.containsKey("puntiacion") ? json["puntuacion"] : null,
    tieneCatalogo: json.containsKey("tieneCatalogo") ? json["tieneCatalogo"] : null,
    latitud: json.containsKey("latitud") ? json["latitud"] : "0",
    longitud: json.containsKey("longitud") ? json["longitud"] : "0"
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "direccion": direccion,
    "telefono": telefono,
    "idMunicipio": idMunicipio,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "objectId": objectId,
    "__type": type,
    "className": className,
    "tieneCatalogo": tieneCatalogo,
    "latitud": latitud,
    "longitud": longitud
  };
}
