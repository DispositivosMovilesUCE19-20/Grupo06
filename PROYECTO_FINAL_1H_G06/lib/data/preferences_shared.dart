import 'package:shared_preferences/shared_preferences.dart';

class Preference{
  static final Preference instance = Preference.internal();
  Preference.internal();
  factory Preference() => instance; 

  static const USER = "user";
  static const USERF = "No hay usuario guardado";
  static const PASSWORD = "password";
  static const PASSWORDF = "No hay password guardada";
  String tempUser="";
  String tempPass="";

  Future<bool> saveDataUser(String user)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(USER, user);
  }

  Future<bool> removeDataUser()async{
    tempUser="";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(USER, tempUser);
  }
  Future<bool> saveDataPassword(String password)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(PASSWORD, password);
  }

  Future<bool> removeDataPassword()async{
    tempPass="";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(PASSWORD, tempPass);
  }

  Future<String> loadDataUser() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(SharedPreferences.getInstance()==null){
      return preferences.getString(USERF);
    }else{
      return preferences.getString(USER);
    }
  }
  
  Future<String> loadDataPassword() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(SharedPreferences.getInstance()==null){
      return preferences.getString(PASSWORDF);
    }else{
      return preferences.getString(PASSWORDF);
    }
  }


}