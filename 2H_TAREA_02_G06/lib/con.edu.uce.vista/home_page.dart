import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optativa_app/com.edu.uce.controller/Utility.dart';
import 'package:optativa_app/com.edu.uce.controller/database_object.dart';
import 'package:optativa_app/com.edu.uce.controller/database_student.dart';
import 'package:optativa_app/com.edu.uce.controller/mensaje_provider.dart';
import 'package:optativa_app/com.edu.uce.controller/preferences_shared.dart';
import 'package:optativa_app/com.edu.uce.model/msg_model.dart';
import 'package:optativa_app/com.edu.uce.model/object_model.dart';
import 'package:optativa_app/com.edu.uce.model/student_model.dart';
import 'package:optativa_app/com.edu.uce.model/user_model.dart';

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1 createState() => _HomePage1();
}

class _HomePage1 extends State<HomePage1> {
  DBHelper2 dbHelper = DBHelper2();
  DBHelper3 dbHelper3 = DBHelper3();
  Future<List<User>> user;
  List<User> users;

  Future<List<Student>> student;
  List<Student> students;

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
    if (aux1 == null && aux2 == null && aux3 == null) {
      aux1 = new Mensaje(msg: mensajeS);
      aux2 = new Mensaje(msg: mensajeS);
      aux3 = new Mensaje(msg: mensajeS);
    }
    setDataMsg();
    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        aux2 = new Mensaje(msg: lisMensaje[1].msg);
        aux1 = new Mensaje(msg: lisMensaje[2].msg);
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
      student = dbHelper.listEst();
    });
  }

  subirTestPhoto() {
    Objeto objeto = new Objeto(
        0, 'cal', 'analisis', 'test', 'YW55IGNhcm5hbCBwbGVhc3VyZS4=');
    dbHelper3.saveObj(objeto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Estudiantes"),
        actions: <Widget>[
          InkWell(
            child: Image.asset(
              "assets/images/registrar.png",
              height: 40.0,
            ),
            onTap: () {
              subirTestPhoto();
              Navigator.pushNamed(context, '/signup_est');
              //_sigunStudent();
            },
          ),
        ],
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
                //Navigator.pop(context);
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
        future: student,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {}
          if (snapshot.hasError) {
            CircularProgressIndicator();
          }
          students = snapshot.data ?? [];
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              Student usera = students[index];
              //return _buildItem(usera);
              return ListTile(
                title: new Text(usera.name),
                subtitle: new Text('Email: ${usera.email}'),
                leading: new Icon(Icons.people),
                trailing: new IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DBHelper2 dbHelper = DBHelper2();
                    showMessageRemove(context);
                    dbHelper.removeEst(usera.name);
                    refreshUser();
                  },
                ),
                onTap: () {
                  _pushUser(usera);
                  print(usera.name);
                  showMessageEdit(context);
                  refreshUser();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            refreshUser();
          },
          label: Text('Actualizar'),
          icon: Icon(Icons.update),
          backgroundColor: Colors.greenAccent),
    );
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

  viewPhoto(String photo) {
    return Utility.imageFromBase64String(photo);
  }

  void _pushUser(Student userPush) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final _formKey = GlobalKey<FormState>();
      TextEditingController nameController;
      TextEditingController lastnameController;
      TextEditingController emailController;
      TextEditingController celularController;
      TextEditingController fechaController;
      int group = 1;
      String genre = userPush.genero;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Editar Perfil"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[            
              Center(
                  child: Container(
                    padding: EdgeInsets.all(40.0),
                    width: 200,
                    height: 300,                  
                    child: viewPhoto(userPush.foto),
                    
                    //child: Text('Foto'),
                  ),
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
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: group,
                          onChanged: (T) {
                            print(T);
                            genre = 'Hombre';
                            setState(() {
                              group = T;
                              print(genre);
                            });
                          },
                        ),
                        Text('Hombre'),
                        Radio(
                          value: 2,
                          groupValue: group,
                          onChanged: (T) {
                            print(T);
                            genre = 'Mujer';
                            setState(() {
                              group = T;
                              print(genre);
                            });
                          },
                        ),
                        Text('Mujer'),
                      ],
                    ),
                    TextFormField(
                        controller: fechaController =
                            TextEditingController(text: userPush.fecha)),
                    RaisedButton(
                      child: Text('Guardar Cambios'),
                      onPressed: () {
                        DBHelper2 dbHelper = DBHelper2();
                        dbHelper.updateEst(
                          userPush.id,
                          nameController.text,
                          lastnameController.text,
                          emailController.text,
                          celularController.text,
                          genre,
                          fechaController.text,
                          userPush.foto
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

  /* void _sigunStudent() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final mensajeProvider = new MensajeProvider();
  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp phoneRegExp =
      new RegExp(r'[09]\d{8}$');

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Registro Estudiante'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Form(
            //key: _formKey,
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
                    
                  },
                ),
                
                RaisedButton(
                  child: Text('Registrar'),
                  onPressed: () {
                    //if (_formKey.currentState.validate()) {
                      DBHelper2 dbHelper = DBHelper2();
                      dbHelper.saveEst(
                        nameController.text,
                        lastnameController.text,
                        emailController.text,
                        celularController.text,
                      );
                      String cont = "0";
                     
                      refreshUser();
                      mensajeProvider.postUser(nameController.text, lastnameController.text, emailController.text, celularController.text);
                      dbHelper.listEst();
                      Navigator.pushReplacementNamed(context, '/login');
                      Navigator.pop(context);
                    //}
                  },
                ),
                  ],
                ),
              ),
            
          ),
        );
      
    }));
  } */
}

//controller: controladorNombre = TextEditingController(text: userPush.name)
