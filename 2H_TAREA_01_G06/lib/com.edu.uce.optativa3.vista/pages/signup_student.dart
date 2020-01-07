import 'dart:io';

import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/database_helper.dart';
import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/database_student.dart';
import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/mensaje_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SignUpStudent extends StatefulWidget {
  @override
   _SignUpStudentState createState() => _SignUpStudentState();
  
}

class _SignUpStudentState extends State<SignUpStudent> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final userEncodeJson = TextEditingController();
  final mensajeProvider = new MensajeProvider();
  String state;
  var _appDocDir;
  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp phoneRegExp =
      new RegExp(r'[09]\d{8}$');
  RegExp passExp= new RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{6,}');

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
          title: Text('Registro Estudiante'),
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
                
                RaisedButton(
                  child: Text('Registrar'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      DBHelper2 dbHelper = DBHelper2();
                      dbHelper.saveEst(
                        nameController.text,
                        lastnameController.text,
                        emailController.text,
                        celularController.text,
                      );
                      String cont = "0";
                     
                      mensajeProvider.postUser(nameController.text, lastnameController.text, emailController.text, celularController.text);
                      dbHelper.listEst();
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