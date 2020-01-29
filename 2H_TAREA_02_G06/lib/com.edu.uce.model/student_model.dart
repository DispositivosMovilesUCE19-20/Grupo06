import 'dart:convert';

class Student {
  String _id;
  String _name;
  String _lastname;
  String _email;
  String _celular;
  String _genero;
  String _fecha;
  String _foto;

  Student(
      this._id,this._name,this._lastname,this._email,this._celular,this._genero,this._fecha,this._foto
  );
  List<Student> listaUsuario = new List();
  Student.fromJsonList(List<dynamic> jsonList){
    if(json == null) return;
    for(var item in jsonList){
      final mensaje = new Student.fromJsonMap(item);
      listaUsuario.add(mensaje);
    }
  }

  String get id => _id;
  String get name => _name;
  String get lastname => _lastname;
  String get email => _email;
  String get celular => _celular;
  String get genero => _genero;
  String get fecha => _fecha;
  String get foto => _foto;


  Map<String, dynamic> toJson()=>
  {
    'id' : id,
    'name' : name,
    'lastname' : lastname,
    'email' : email,
    'celular' : celular,
    'genero' : genero,
    'fecha' : fecha,
    'foto' : foto
  };
   Student.fromJsonMap(Map<String, dynamic> json){
    _id = json['id'];
    _name=json['name'];
    _lastname=json['lastname'];
    _email=json['email'];
    _celular=json['celular'];
    _genero=json['genero'];
    _fecha=json['fecha'];
    _foto=json['foto'];
  }
  







  @override
  String toString() {
    return 'Student{id: $id, name: $name, lastname: $lastname, email: $email, celular: $celular }';
  }

}
