import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:optativa_app/com.edu.uce.controller/database_helper.dart';
import 'package:optativa_app/com.edu.uce.controller/mensaje_provider.dart';
import 'package:optativa_app/com.edu.uce.controller/preferences_shared.dart';
import 'package:optativa_app/com.edu.uce.model/msg_model.dart';
import 'package:optativa_app/com.edu.uce.model/user_model.dart';
import 'package:speech_recognition/speech_recognition.dart';

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
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();


  
  Future<List<Mensaje>> lista;
  List<Mensaje> tempList;
  Mensaje aux;
  Mensaje aux3;
  String mensajeL;
  String mensajeT;
  String mensajeS = "Esperando datos....";
  String textValue = 'Hello World !';

  double rating = 0.0;

  Light _light;
  StreamSubscription _subscription;
  @override
  void initState() {
    super.initState();
    firebaseMessaging.getToken().then((token) {
    print(token);
    });
    if (aux == null && aux3 == null) {
      aux = new Mensaje(msg: mensajeS);
      aux3 = new Mensaje(msg: mensajeS);
    }

    setDataMsg();
    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        aux = new Mensaje(msg: lisMensaje[0].msg);
        aux3 = new Mensaje(msg: lisMensaje[3].msg);
        mensajeT = aux.msg.toString();
        mensajeL = aux3.msg.toString();
      }
    });

    initSpeechRecognizer();
  }

 /*  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token": token});
    textValue = token;
    setState(() {});
  } */

  void onData(int luxValue) async {
    print("Valor para el sensor de luz: $luxValue");
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription.cancel();
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

  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  @override
  Widget build(BuildContext context) {
    onData(0);
    startListening();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Image.asset(
          "assets/images/logo.png",
          height: 40.0,
        ),
        actions: <Widget>[
          Text("Registrate->",
              style: TextStyle(fontSize: 20.0), textAlign: TextAlign.left),
          InkWell(
            child: Image.asset(
              "assets/images/regis.png",
              height: 40.0,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        /* child: Form(
              key: _formKey, */
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              aux.msg.toString(),
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            ),
            /* TextFormField(
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
                  ), */

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "btn1",
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    if (_isListening)
                      _speechRecognition.cancel().then(
                            (result) => setState(() {
                              _isListening = result;
                              resultText = "";
                            }),
                          );
                  },
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  child: Icon(Icons.mic),
                  onPressed: () {
                    if (_isAvailable && !_isListening)
                      _speechRecognition
                          .listen(locale: "es_EC")
                          .then((result) => print('$result'));
                  },
                  backgroundColor: Colors.blue,
                ),
                FloatingActionButton(
                  heroTag: "btn3",
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: () {
                    if (_isListening)
                      _speechRecognition.stop().then(
                            (result) => setState(() => _isListening = result),
                          );
                  },
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
            RaisedButton(
              child: Text(
                'Ingresar',
                style: TextStyle(fontSize: 20),
              ),
              padding: EdgeInsets.all(4.0),
              onPressed: () {
                String tempVoz = resultText;
                _autenticacionVoz(tempVoz);
              },
            ),
            Text(
              tempU ?? 'No hay registros',
              style: TextStyle(fontSize: 20),
            ),
            Center(
              child: Slider(
                value: rating,
                label: "$rating",
                onChanged: (newRating) {
                  setState(() => rating = newRating);
                  print("$rating");
                },
              ),
            ),
            /* OutlineButton(
                    child: Text("Ultimo usuario que ingreso"),
                    onPressed: () {
                      setDataUser();
                      //Navigator.pushNamed(context, '/signup_est');
                    },
                  ), */
          ],
        ),
        //),
      ),
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

  _autenticacionVoz(String reconocer) {
    String diego = "Diego Quesada";
    String josu = "Josué Lita";
    String yandry = "yandry Torres";
    String henry = "Henry Rodríguez";
    if (reconocer == diego ||
        reconocer == josu ||
        reconocer == yandry ||
        reconocer == henry) {
      Navigator.pushReplacementNamed(context, '/home');
      print('[LoginPage] _authenticateUser: Success');
    } else {
      print('[LoginPage] _authenticateUser: Invalid credentials');
    }
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
