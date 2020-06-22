// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

MunicipioResult municipioResultFromJson(String str) => MunicipioResult.fromJson(json.decode(str));

String municipioResultToJson(MunicipioResult data) => json.encode(data.toJson());

class MunicipioResult {
  Result result;

  MunicipioResult({
    this.result,
  });

  factory MunicipioResult.fromJson(Map<String, dynamic> json) => MunicipioResult(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class Result {
  String mensaje;
  int code;
  List<Municipio> object;

  Result({
    this.mensaje,
    this.code,
    this.object,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    mensaje: json["mensaje"],
    code: json["code"],
    object: List<Municipio>.from(json["object"].map((x) => Municipio.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mensaje": mensaje,
    "code": code,
    "object": List<dynamic>.from(object.map((x) => x.toJson())),
  };
}

class Municipio {
  String nombre;
  bool disponible;
  DateTime createdAt;
  DateTime updatedAt;
  String objectId;
  Type type;
  ClassName className;

  Municipio({
    this.nombre,
    this.disponible,
    this.createdAt,
    this.updatedAt,
    this.objectId,
    this.type,
    this.className,
  });

  factory Municipio.fromJson(Map<String, dynamic> json) => Municipio(
    nombre: json["nombre"],
    disponible: json["disponible"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    objectId: json["objectId"],
    type: typeValues.map[json["__type"]],
    className: classNameValues.map[json["className"]],
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "disponible": disponible,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "objectId": objectId,
    "__type": typeValues.reverse[type],
    "className": classNameValues.reverse[className],
  };
}

enum ClassName { MUNICIPIO }

final classNameValues = EnumValues({
  "Municipio": ClassName.MUNICIPIO
});

enum Type { OBJECT }

final typeValues = EnumValues({
  "Object": Type.OBJECT
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
