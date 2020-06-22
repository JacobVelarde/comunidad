// To parse this JSON data, do
//
//     final servicioLocal = servicioLocalFromJson(jsonString);

import 'dart:convert';

ServicioLocal servicioLocalFromJson(String str) => ServicioLocal.fromJson(json.decode(str));

String servicioLocalToJson(ServicioLocal data) => json.encode(data.toJson());

class ServicioLocal {
  List<String> servicio;

  ServicioLocal({
    this.servicio,
  });

  factory ServicioLocal.fromJson(Map<String, dynamic> json) => ServicioLocal(
    servicio: List<String>.from(json["servicio"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "servicio": List<dynamic>.from(servicio.map((x) => x)),
  };
}