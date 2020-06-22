import 'dart:convert';

ServerResult serverResultFromJson(String str) => ServerResult.fromJson(json.decode(str));

String serverResultToJson(ServerResult data) => json.encode(data.toJson());

class ServerResult {
  Result result;

  ServerResult({
    this.result,
  });

  factory ServerResult.fromJson(Map<String, dynamic> json) => ServerResult(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class Result {
  String mensaje;
  int code;

  Result({
    this.mensaje,
    this.code,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    mensaje: json["mensaje"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "mensaje": mensaje,
    "code": code,
  };
}