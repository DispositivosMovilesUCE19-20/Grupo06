import 'dart:convert';

class User {
  String _id;
  String _user;
  String _password;

  User(
      this._id,this._user,this._password
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
  String get user => _user;
  String get password => _password;


  Map<String, dynamic> toJson()=>
  {
    'id' : id,
    'user' : user,
    'password' : password
  };
   User.fromJsonMap(Map<String, dynamic> json){
    _id = json['id'];
    _user=json['name'];
    _password=json['name'];
  }
  







  @override
  String toString() {
    return 'User{id: $id, user: $user, password: $password}';
  }

}
