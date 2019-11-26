import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/database_helper.dart';
import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/mensaje_provider.dart';
import 'package:app_optativa/com.edu.uce.optativa3.controlador/data/preferences_shared.dart';
import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/msg_model.dart';
import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/user_model.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String tempU = "";
  String tempP = "";
  String userKey = "_key_user";
  String passwordKey = "_key_password";
  

  final mensajeProvider = new MensajeProvider();
  Future<List<Mensaje>> lista;
  List<Mensaje> tempList;
  Mensaje aux;
   Mensaje aux3;
  String mensajeL;
  String mensajeT;
  String mensajeS = "Esperando datos....";

  @override
  void initState() {
    super.initState();
    if (aux == null && aux3==null) {
      aux = new Mensaje(msg: mensajeS);
      aux3 = new Mensaje(msg: mensajeS);
    }
    
    setDataMsg();
    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        aux = new Mensaje(msg: lisMensaje[0].msg);
        aux3 = new Mensaje(msg:lisMensaje[3].msg);
        mensajeT = aux.msg.toString();
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

  setDataUser() {
     Preference.instance.loadDataUser().then((value) {
      setState(() {
        tempU = value;
      });
    });
   }
    

  setDataPassword() {
    Preference.instance.loadDataPassword().then((value) {
      setState(() {
        tempP = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Image.asset(
          "assets/images/logo.png",
          height: 40.0,
        ),
        actions: <Widget>[
          Text("Registrate->",
              style: TextStyle(fontSize: 20.0), textAlign: TextAlign.left),
          InkWell(
            child: Image.asset(
              "assets/images/registrar.png",
              height: 40.0,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    aux.msg.toString(),
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  TextFormField(
                    controller: usuarioController,
                    decoration: InputDecoration(labelText: 'Usuario'),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingresa tu usuario';
                      }
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingresa tu password';
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Ingresar',
                      style: TextStyle(fontSize: 20),
                    ),
                    padding: EdgeInsets.all(4.0),
                    onPressed: _authenticateUser,
                    
                    
                  ),
                  
                  Text(tempU??'No hay registros',style: TextStyle(fontSize: 20),),
                  OutlineButton(
                    child: Text("Ultimo usuario que ingreso"),
                    onPressed: () {
                      setDataUser();
                    },
                  ),          
        
                ],

              ),
            ),
          )),
      
    );
  }
  showMessagelogin(context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green[300],
      content:
          Text(mensajeL, style: TextStyle(fontSize: 15.0, color: Colors.white)),
      duration: Duration(seconds: 2),
    ));
  }

  _authenticateUser() async {
    if (_formKey.currentState.validate()) {
      DBHelper dbHelper = DBHelper();
      dbHelper
          .getUser(usuarioController.text, passwordController.text)
          .then((List<User> users) {
        if (users != null && users.length > 0) {
          Preference.instance.saveDataUser(usuarioController.text);
          Preference.instance.saveDataPassword(passwordController.text);          
          Navigator.pushReplacementNamed(context, '/home');
          showMessagelogin(context);
          print('[LoginPage] _authenticateUser: Success');
          
        } else {
          print('[LoginPage] _authenticateUser: Invalid credentials');
        }
      });
    }
  }
}
