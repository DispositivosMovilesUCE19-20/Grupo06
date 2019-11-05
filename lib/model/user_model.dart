class User {
  String _id;
  String _name;
  String _lastname;
  String _email;
  String _celular;
  String _user;
  String _password;

  User(
    this._id,
    this._name,
    this._lastname,
    this._email,
    this._celular,
    this._user,
    this._password,
  );

  String get id => _id;
  String get name => _name;
  String get lastname => _lastname;
  String get email => _email;
  String get celular => _celular;
  String get user => _user;
  String get password => _password;

  @override
  String toString() {
    return 'User{id: $id, nombre: $name, apellido: $lastname, email: $email, celular: $celular, user: $user, password: $password}';
  }

}