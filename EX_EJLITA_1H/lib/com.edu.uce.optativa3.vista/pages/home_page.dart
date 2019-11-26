import 'dart:io';

import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/database_helper.dart';
import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/mensaje_provider.dart';
import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/preferences_shared.dart';
import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/msg_model.dart';
import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1 createState() => _HomePage1();
}

class _HomePage1 extends State<HomePage1> {
  DBHelper dbHelper = DBHelper();
  Future<List<User>> user;
  List<User> users;
  final mensajeProvider = new MensajeProvider();
  Future<List<Mensaje>> lista;
  List<Mensaje> tempList;
  Mensaje aux1;
  Mensaje aux2;
  Mensaje aux3;
  String mensajeL;
  String mensajeU;
  String mensajeR;
  String mensajeS = "Esperando datos....";
  @override
  void initState() {
    super.initState();
    refreshUser();
    if (aux1 == null && aux2 == null && aux3==null) {
      aux1 = new Mensaje(msg: mensajeS);
      aux2 = new Mensaje(msg: mensajeS);
      aux3 = new Mensaje(msg: mensajeS);
    }
    setDataMsg();
    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        aux2 = new Mensaje(msg: lisMensaje[1].msg);
        aux1 = new Mensaje(msg: lisMensaje[3].msg);
        aux3 = new Mensaje(msg: lisMensaje[3].msg);
        mensajeU = aux2.msg.toString();
        mensajeR = aux1.msg.toString();
        mensajeL = aux3.msg.toString();
      }
    });
  }

  setDataMsg() {
    mensajeProvider.getData().then((value) {
      setState(() {
        tempList = value;
      });
    });
  }

  refreshUser() {
    setState(() {
      user = dbHelper.listUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Usuario Registrados"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                child: DrawerHeader(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        size: 70.0,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Cerrar Sesion',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  Preference.instance.removeDataUser();
                  Preference.instance.removeDataPassword();
                  Navigator.pushReplacementNamed(context, '/login');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Salir',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  exit(0);
                },
              )
            ],
          ),
        ),
        body: new FutureBuilder(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {}
            if (snapshot.hasError) {
              CircularProgressIndicator();
            }
            users = snapshot.data ?? [];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User usera = users[index];
                //return _buildItem(usera);
                return ListTile(
                  title: new Text(usera.user),
                  subtitle: new Text('Email: ${usera.email}'),
                  leading: new Icon(Icons.people),
                  trailing: new IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      DBHelper dbHelper = DBHelper();
                      showMessageRemove(context);
                      dbHelper.removeUser(usera.user);
                      refreshUser();
                    },
                  ),
                  onTap: () {
                    _pushUser(usera);
                    print(usera.name);
                    showMessageEdit(context);
                    
                  },
                );
              },
            );
          },
        ));
  }

  showMessageRemove(context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content:
          Text(mensajeR, style: TextStyle(fontSize: 15.0, color: Colors.white)),
      duration: Duration(seconds: 2),
    ));
  }

  showMessageEdit(context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green[300],
      content:
          Text(mensajeU, style: TextStyle(fontSize: 15.0, color: Colors.white)),
      duration: Duration(seconds: 2),
    ));
  }

  showMessagelogin(context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green[300],
      content:
          Text(mensajeL, style: TextStyle(fontSize: 15.0, color: Colors.white)),
      duration: Duration(seconds: 2),
    ));
  }

  void _pushUser(User userPush) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final _formKey = GlobalKey<FormState>();
      TextEditingController nameController;
      TextEditingController lastnameController;
      TextEditingController emailController;
      TextEditingController celularController;
      TextEditingController usuarioController;
      TextEditingController passwordController;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Editar Perfil"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.supervised_user_circle,
                size: 150,
              ),
              Form(
                //key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: nameController =
                            TextEditingController(text: userPush.name)),
                    TextFormField(
                        controller: lastnameController =
                            TextEditingController(text: userPush.lastname)),
                    TextFormField(
                        controller: emailController =
                            TextEditingController(text: userPush.email)),
                    TextFormField(
                        controller: celularController =
                            TextEditingController(text: userPush.celular)),
                    TextFormField(
                        controller: usuarioController =
                            TextEditingController(text: userPush.user)),
                    TextFormField(
                        obscureText: true,
                        controller: passwordController =
                            TextEditingController(text: userPush.password)),
                    RaisedButton(
                      child: Text('Guardar Cambios'),
                      onPressed: () {
                        DBHelper dbHelper = DBHelper();
                        dbHelper.updateUser(
                          userPush.id,
                          nameController.text,
                          lastnameController.text,
                          emailController.text,
                          celularController.text,
                          usuarioController.text,
                          passwordController.text,
                        );
                        refreshUser();
                        Navigator.pushReplacementNamed(context, '/home');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}

//controller: controladorNombre = TextEditingController(text: userPush.name)
