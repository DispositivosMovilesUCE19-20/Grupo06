import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/msg_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';




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

  postUser(String name, String lastname, String email, String celular, String user, String password) async{

    String url = 'https://servicio1-project.herokuapp.com/datosEstudiantes';
    Map<String, String> headers = {"Content-type": "application/json"};
     String json = '{"id": "20", "name": "${name}", "lastname": "${lastname}", "email": "${email}", "celular": "${celular}", "user": "${user}", "password": "${password}"}';

     Response response = await post(url, headers: headers, body: json);
  }
}