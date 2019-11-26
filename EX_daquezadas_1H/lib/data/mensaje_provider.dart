import 'package:app_optativa/model/msg_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';




class MensajeProvider{

  //Metodo para procesar el json

  //Listo los mensajes
  Future<List<Mensaje>> getData() async{
    http.Response res = await http.get(
      Uri.encodeFull("https://servicio1-project.herokuapp.com/mensajeGrupo06"),
      headers: {
        "Accept": "application/json"
      }
    );
    final decode =await json.decode(res.body);
    //print(decode);
    final mensaje = new Mensajes.fromJsonList(decode);
    print(mensaje.lista[0].msg);
    return mensaje.lista;
  }
}