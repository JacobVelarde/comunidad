
mixin Validaciones{

  String validaTelefono(String value){
    bool telefonoValido = RegExp("^[0-9]*\$").hasMatch(value);
    bool longitud = false;
    if (value.length == 10){
      longitud = true;
    }
    if (telefonoValido && longitud){
      return null;
    }else{
      return "Ingresa un telefono valido";
    }
  }

  String validaPrecio(String value){
    bool validaPrecio = RegExp("^[0-9]+(\.[0-9]{1,2})?\$").hasMatch(value);

    if (validaPrecio){
      return null;
    }else{
      return "Ingresa un precio correcto, ejemplo: 12.50";
    }
  }

  String validaDireccion(String value){
    if (value.length > 5){
      return null;
    }else{
      return "Ingresa una dirección valida";
    }
  }

  String validaNombre(String value){
    if (value.length > 1){
      return null;
    }else{
      return "Ingresa un nombre valido";
    }
  }

  String validaDescripcion(String value){
    if (value.length > 10){
      return null;
    }else{
      return "Agrega una buena descripción de tu producto";
    }
  }

  String validaDescripcionNegocio(String value){
    if (value.length > 5){
      return null;
    }else{
      return "Agrega una buena descripcion de tu servicio o negocio";
    }
  }

  String validaPasswod(String value){
    if (value.length > 3){
      return null;
    }else{
      return "Agrega una contraseña mas segura";
    }
  }

}