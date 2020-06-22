// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Servicio servicioFromJson(String str) => Servicio.fromJson(json.decode(str));

String servicioToJson(Servicio data) => json.encode(data.toJson());

class Servicio {
  String id;
  String nombre;
  String direccion;
  String idMunicipio;
  String telefonoContacto;
  String puntuacion;
  bool isServicio;
  String descripcion;
  bool tieneCatalogo;
  String idNegocio;
  String latitud;
  String longitud;

  Servicio({
    this.id,
    this.nombre,
    this.direccion,
    this.telefonoContacto,
    this.idMunicipio,
    this.puntuacion,
    this.isServicio,
    this.descripcion,
    this.tieneCatalogo,
    this.idNegocio,
    this.latitud,
    this.longitud
  });

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
    id: json["id"],
    nombre: json["nombre"],
    direccion: json["direccion"],
    telefonoContacto: json["telefonoContacto"],
    puntuacion: json["puntuacion"],
    isServicio: json["isServicio"],
    descripcion: json["descripcion"],
    tieneCatalogo: json["tieneCatalogo"],
    idNegocio: json["idNegocio"],
    latitud: json["latitud"],
    longitud: json["longitud"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "direccion": direccion,
    "idMunicipio": idMunicipio,
    "telefonoContacto": telefonoContacto,
    "puntuacion": puntuacion,
    "isServicio": isServicio,
    "descripcion": descripcion,
    "tieneCatalogo": tieneCatalogo,
    "idNegocio": idNegocio,
    "latitud": latitud,
    "longitud": longitud,
  };
}
