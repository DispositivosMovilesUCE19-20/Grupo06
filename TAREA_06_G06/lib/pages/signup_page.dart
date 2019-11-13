import 'dart:convert';
import 'dart:io';

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
  String state;
  var _appDocDir;
  
  @override
  void initState() {
    super.initState();
    DBHelper dbHelper = DBHelper();
    dbHelper.readJson().then((String value){
      setState(() {
        state=value;
      });
    });

  }

  Future<File> writeData() async{
    setState(() {
      state = userEncodeJson.text;
      userEncodeJson.text='';
    });

    return DBHelper.internal().writeJson(state);
  }

  void getAppDirectory(){
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
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Por favor ingresa tu Email';
                        }
                      },
                    ),
                    TextFormField(
                      controller: celularController,
                      decoration: InputDecoration(labelText: 'Celular'),
                      keyboardType: TextInputType.number,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Por favor ingresa tu numero celular';
                        }
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
    
                          User userJson = new User(
                              "j1",
                              nameController.text,
                              lastnameController.text,
                              emailController.text,
                              celularController.text,
                              usuarioController.text,
                              passwordController.text);
                              userEncodeJson.text = jsonEncode(userJson);
    
                          dbHelper.listUser();
    
                          Navigator.pushReplacementNamed(context, '/login');
                          Navigator.pop(context);
                        }
                      },
                    ),
                    OutlineButton(
                      child: Text("Escribir el usuario en el archivo Json"),
                      onPressed: writeData,
    
                    ),
                   OutlineButton(
                     child: Text("Mostrar Directorio del Json"),
                     onPressed: getAppDirectory,
                   ),
                   FutureBuilder<Directory>(
                     future: _appDocDir,
                     builder: (BuildContext context, AsyncSnapshot<Directory> snapshot){
                       Text text = Text('');
                       if(snapshot.connectionState==ConnectionState.done){
                         if(snapshot.hasError){
                           text =Text('Error: ${snapshot.error}');
                         }else if(snapshot.hasData){
                           text = Text('path: ${snapshot.data.path}');
                         }else{
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
