import 'dart:convert';

class User {
  String _id;
  String _name;
  String _lastname;
  String _email;
  String _celular;
  String _user;
  String _password;

  User(
      this._id,this._name,this._lastname,this._email,this._celular,this._user,this._password
  );
  List<User> listaUsuario = new List();
  User.fromJsonList(List<dynamic> jsonList){
    if(json == null) return;
    for(var item in jsonList){
      final mensaje = new User.fromJsonMap(item);
      listaUsuario.add(mensaje);
    }
  }

  String get id => _id;
  String get name => _name;
  String get lastname => _lastname;
  String get email => _email;
  String get celular => _celular;
  String get user => _user;
  String get password => _password;


  Map<String, dynamic> toJson()=>
  {
    'id' : id,
    'name' : name,
    'lastname' : lastname,
    'email' : email,
    'celular' : celular,
    'user' : user,
    'password' : password
  };
   User.fromJsonMap(Map<String, dynamic> json){
    _id = json['id'];
    _lastname=json['name'];
    _email=json['name'];
    _celular=json['name'];
    _user=json['name'];
    _password=json['name'];
  }
  







  @override
  String toString() {
    return 'User{id: $id, nombre: $name, apellido: $lastname, email: $email, celular: $celular, user: $user, password: $password}';
  }

}

