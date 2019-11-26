import 'dart:convert';
import 'dart:io';

import 'package:app_optativa/data/mensaje_provider.dart';
import 'package:app_optativa/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:app_optativa/data/database_helper.dart';
import 'package:path_provider/path_provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  final userEncodeJson = TextEditingController();
  final mensajeProvider = new MensajeProvider();
  String state;
  var _appDocDir;
  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp phoneRegExp =
      new RegExp(r'[09]\d{8}$');

  @override
  void initState() {
    super.initState();
    DBHelper dbHelper = DBHelper();
    dbHelper.readJson().then((String value) {
      setState(() {
        state = value;
      });
    });
  }

  Future<File> writeData() async {
    setState(() {
      state = userEncodeJson.text;
      userEncodeJson.text = '';
    });

    return DBHelper.internal().writeJson(state);
  }

  void getAppDirectory() {
    setState(() {
      _appDocDir = getApplicationDocumentsDirectory();
    });
  }

  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Registro'),
          actions: <Widget>[Text('SERVICIO GRUPO 06')],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                  },
                ),
                TextFormField(
                  controller: lastnameController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.length == 0) {
                      return "Este campo correo es requerido";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "El formato para correo no es correcto";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: celularController,
                  decoration: InputDecoration(labelText: 'Celular'),
                  keyboardType: TextInputType.number,
                  validator:  (text) {
                    if (text.length == 0) {
                      return "Este campo telefono es requerido";
                    } else if (!phoneRegExp.hasMatch(text)) {
                      return "El formato para telefono no es correcto";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: usuarioController,
                  decoration: InputDecoration(labelText: 'Usuario'),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Por favor ingresa tu Usuario';
                    }
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Por favor ingresa password';
                    }
                  },
                ),
                RaisedButton(
                  child: Text('Registrar'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      DBHelper dbHelper = DBHelper();
                      dbHelper.saveUser(
                        nameController.text,
                        lastnameController.text,
                        emailController.text,
                        celularController.text,
                        usuarioController.text,
                        passwordController.text,
                      );
                      String cont = "0";
                     
                      mensajeProvider.postUser(nameController.text, lastnameController.text, emailController.text, celularController.text, usuarioController.text, passwordController.text);
                      dbHelper.listUser();
                      Navigator.pushReplacementNamed(context, '/login');
                      Navigator.pop(context);
                    }
                  },
                ),
                OutlineButton(
                  child: Text("Mostrar Directorio del Json"),
                  onPressed: getAppDirectory,
                ),
                FutureBuilder<Directory>(
                  future: _appDocDir,
                  builder: (BuildContext context,
                      AsyncSnapshot<Directory> snapshot) {
                    Text text = Text('');
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        text = Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        text = Text('path: ${snapshot.data.path}');
                      } else {
                        text = Text('Inaccesible');
                      }
                    }
                    return new Container(
                      child: text,
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }

  
}