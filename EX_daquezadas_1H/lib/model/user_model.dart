class User {
  String _id;
  String _name;
  String _lastname;
  String _email;
  String _celular;
  String _user;
  String _password;
  String _genero;

  User(
      this._id,this._name,this._lastname,this._email,this._celular,this._user,this._password, this._genero
  );

  String get id => _id;
  String get name => _name;
  String get lastname => _lastname;
  String get email => _email;
  String get celular => _celular;
  String get user => _user;
  String get password => _password;
  String get genero=> _genero;


  Map<String, dynamic> toJson()=>
  {
    'id' : id,
    'name' : name,
    'lastname' : lastname,
    'email' : email,
    'celular' : celular,
    'user' : user,
    'password' : password,
    'genero' : genero
  };
  







  @override
  String toString() {
    return 'User{id: $id, nombre: $name, apellido: $lastname, email: $email, celular: $celular, user: $user, password: $password}';
  }

}