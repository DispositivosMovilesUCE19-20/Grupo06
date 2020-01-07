import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/student_model.dart';
import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  DBHelper.internal();
  factory DBHelper() =>
      _instance; // nos va a devolver la instancia con los mismos datos
  static Database _db;
  String userEncodeJson = "";

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'usuarios_test.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,  
    );
    print('[DBHelper] initDB: Success');
    return db;
  }

  Future<String> get localPathJson async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<io.File> get localFile async {
    final path = await localPathJson;
    return io.File('$path/jsonUser.json');
  }

  Future<String> readJson() async {
    try {
      final json = await localFile;
      String body = await json.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<io.File> writeJson(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }

  void _createTables(Database db, int version) async {
    await db.execute(
      'CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT,user TEXT, password TEXT)',
      
    );
    print('[DBHelper] _createTables: Success');
  }

  void saveUser(String user, String password) async {
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawInsert(
        'INSERT INTO User(user, password) VALUES(\'$user\', \'$password\')',
      );
    });
    print(
        '[DBHelper] saveUser: Success | $user, $password');    
  }


  removeUser(String user) async {
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawDelete('DELETE FROM User Where user=\'$user\'');
    });
  }
  
updateUser(String id, String user, String password) async{
    var dbClient = await db;
    await dbClient.transaction((trans) async{
      return await trans.rawUpdate('UPDATE User SET  user=\'$user\', password=\'$password\' WHERE id =\'$id\'');
    });
    print(
        '[DBHelper] updateUser: Success |  $user, $password');
      
  }

  
  Future<List<User>> listUser() async {
    var dbClient = await db;
    final List<User> usersList = List();
    List<Map> queryList = await dbClient.rawQuery(
      'SELECT * FROM User ',
    );
    if (queryList != null && queryList.length > 0) {
      for (int i = 0; i < queryList.length; i++) {
        usersList.add(User(
          queryList[i]['id'].toString(),
          queryList[i]['user'],
          queryList[i]['password'],
        ));
      }
    }
    print(usersList);
    return usersList;
  }

  getUniqueUser(String user, String password){
   
    
  }

  Future<List<User>> getUser(String user, String password) async {
    var dbClient = await db;
    List<User> usersList = List();
    List<Map> queryList = await dbClient.rawQuery(
      'SELECT * FROM User WHERE user=\'$user\' AND password=\'$password\'',
    );
    print('[DBHelper] getUser: ${queryList.length} users');
    if (queryList != null && queryList.length > 0) {
      for (int i = 0; i < queryList.length; i++) {
        usersList.add(User(
          queryList[i]['id'].toString(),
          queryList[i]['user'],
          queryList[i]['password'],
        ));
      }
      print('[DBHelper] getUser: ${usersList[0].user}');
      return usersList;
    } else {
      print('[DBHelper] getUser: User is null');
      return null;
    }
  }
}
