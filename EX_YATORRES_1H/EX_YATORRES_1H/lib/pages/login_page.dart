import 'package:app_optativa/data/mensaje_provider.dart';
import 'package:app_optativa/data/preferences_shared.dart';
import 'package:app_optativa/model/msg_model.dart';
import 'package:flutter/material.dart';
import 'package:app_optativa/model/user_model.dart';
import 'package:app_optativa/data/database_helper.dart';

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
  String mensajeT;
  String mensajeS = "Esperando datos....";

  @override
  void initState() {
    super.initState();
    if (aux == null) {
      aux = new Mensaje(msg: mensajeS);
    }
    
    setDataMsg();
    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        aux = new Mensaje(msg: lisMensaje[0].msg);
        mensajeT = aux.msg.toString();
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
                    //onChanged: (value) {},
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
                    //onChanged: (value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return validatePassword(value);
                        //return 'Por favor ingresa tu password';
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
  showMessageLogin(context){
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green[300],
      content: Text('Credenciales incorrectas', style: TextStyle(fontSize: 15.0,color: Colors.white)),
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
          Navigator.pushNamed(context, '/home');
          print('[LoginPage] _authenticateUser: Success');
          
        } else {
          print('[LoginPage] _authenticateUser: Invalid credentials');
        }
      });
    }
  
  }
  String validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value))
        return 'Enter valid password';
      else
        return null;
    }
  }



}
