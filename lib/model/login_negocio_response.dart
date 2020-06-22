// To parse this JSON data, do
//
//     final loginNegocioResponse = loginNegocioResponseFromJson(jsonString);

import 'dart:convert';

LoginNegocioResponse loginNegocioResponseFromJson(String str) => LoginNegocioResponse.fromJson(json.decode(str));

String loginNegocioResponseToJson(LoginNegocioResponse data) => json.encode(data.toJson());

class LoginNegocioResponse {
  Result result;

  LoginNegocioResponse({
    this.result,
  });

  factory LoginNegocioResponse.fromJson(Map<String, dynamic> json) => LoginNegocioResponse(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class Result {
  String mensaje;
  int code;
  Object object;

  Result({
    this.mensaje,
    this.code,
    this.object,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    mensaje: json["mensaje"],
    code: json["code"],
    object: json.containsKey("object") ? Object.fromJson(json["object"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "mensaje": mensaje,
    "code": code,
    "object": object.toJson(),
  };
}

class Object {
  String titular;
  String telefono;
  String nombreNegocio;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  String objectId;
  String type;
  String className;

  Object({
    this.titular,
    this.telefono,
    this.nombreNegocio,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.objectId,
    this.type,
    this.className,
  });

  factory Object.fromJson(Map<String, dynamic> json) => Object(
    titular: json["titular"],
    telefono: json["telefono"],
    nombreNegocio: json["nombreNegocio"],
    password: json["password"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    objectId: json["objectId"],
    type: json["__type"],
    className: json["className"],
  );

  Map<String, dynamic> toJson() => {
    "titular": titular,
    "telefono": telefono,
    "nombreNegocio": nombreNegocio,
    "password": password,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "objectId": objectId,
    "__type": type,
    "className": className,
  };
}
