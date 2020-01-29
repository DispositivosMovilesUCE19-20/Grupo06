import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:optativa_app/com.edu.uce.controller/Utility.dart';
import 'package:optativa_app/com.edu.uce.controller/database_helper.dart';
import 'package:optativa_app/com.edu.uce.controller/database_object.dart';
import 'package:optativa_app/com.edu.uce.controller/database_student.dart';
import 'package:optativa_app/com.edu.uce.controller/mensaje_provider.dart';
import 'package:optativa_app/com.edu.uce.model/object_model.dart';
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
  TextEditingController fechaController;
  final userEncodeJson = TextEditingController();
  final mensajeProvider = new MensajeProvider();
  String state;
  int group = 1;
  String genre='Hombre';
  Future<File> imageFile;
  Image image;
  DBHelper3 dbHelper3;
  List<Objeto> images;
  String tempFoto;

  DateTime _currentdate = new DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,        
        initialDate: _currentdate,
        firstDate: DateTime(1970),
        lastDate: DateTime(2024));

    if (_seldate != null) {
      setState(() {
        _currentdate = _seldate;
      });
    }
  }

  var _appDocDir;
  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp phoneRegExp =
      new RegExp(r'[09]\d{8}$');
  RegExp passExp= new RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{6,}');

  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper3 = DBHelper3();
    refreshImages();
  }

  refreshImages() {
    dbHelper3.getObjeto().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  subirTestPhoto() {
    Objeto objeto =
        new Objeto(0, 'cal', 'analisis', 'test1', 'YW55IGNhcm5hbCBwbGVhc3VyZS4=');
    dbHelper3.saveObj(objeto);
  }

  deletePhoto() {
    dbHelper3.removeAllPhoto();
  }

  viewPhoto() {
    return Utility.imageFromBase64String(images[images.length - 1].foto);
  }

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      tempFoto = imgString;
      Objeto objeto = new Objeto(2, 'cal', 'analisis', 'test1', imgString);
      dbHelper3.saveObj(objeto);
      refreshImages();
    });
  }

  pickImageFromCamera() {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      tempFoto = imgString;
      Objeto objeto = new Objeto(2, 'cal', 'analisis', 'test1', imgString);
      dbHelper3.saveObj(objeto);
      refreshImages();
    });
  }
  

  @override
  Widget build(BuildContext context) {
    String _formatDate = DateFormat.yMd().format(_currentdate);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Registro Estudiante'),
        ),
           body: SingleChildScrollView(
          //padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.all(40.0),
                    width: 200,
                    height: 300,                  
                    child: viewPhoto(),
                    
                    //child: Text('Foto'),
                  ),
                ),
                
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
                Row(
                  children: <Widget>[
                    Text('Selecciona tu género'),
                    Radio(
                      value: 1,
                      groupValue: group,
                      onChanged: (T){
                        print(T);
                        genre='Hombre';   
                        setState(() {
                          group=T;                        
                          print(genre);
                        });
                      },
                    ),
                    Text('Hombre'),
                    Radio(
                      value: 2,
                      groupValue: group,
                      onChanged: (T){
                        print(T);
                        genre='Mujer';                       
                        setState(() {
                          group=T;
                          print(genre);
                        });
                      },
                    ),
                    Text('Mujer')
                  ],
                ),
                
      
                    TextFormField(                
                  controller: fechaController =
                      TextEditingController(text: _formatDate)
                ),
                OutlineButton(
                  child: Icon(Icons.calendar_today),
                  onPressed:()=>_selectDate(context),
                ),
                 
                
              Row(
                children: <Widget>[
                  Spacer(),
                  OutlineButton(
                  child: Text('Agrega una foto'),
                  onPressed: (){
                    pickImageFromGallery();
                  },
                ),
                Spacer(),
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
                        genre,
                        fechaController.text,
                        tempFoto
                      );
                      String cont = "0";
                      
                      mensajeProvider.postUser(nameController.text, lastnameController.text, emailController.text, celularController.text);
                      dbHelper.listEst();
                      deletePhoto();
                      Navigator.pushReplacementNamed(context, '/login');
                      Navigator.pop(context);
                    }
                  },
                ), 
                Spacer(),
                OutlineButton(
                  child: Text('Toma una foto'),
                  onPressed: (){
                    pickImageFromCamera();
                  },
                ),
                Spacer()
                ],
              ),                      
              ],
            ),
          ),
        ));
  }

  
}