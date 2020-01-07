import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/student_model.dart';
import 'package:app_optativa/com.edu.uce.optativa3.modelo/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';



class DBHelper2 {
  static final DBHelper2 _instance = DBHelper2.internal();
  DBHelper2.internal();
  factory DBHelper2() =>
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
    String path = join(documentsDirectory.path, 'estudiantes_test.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _createTableEst,
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


   void _createTableEst(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Student(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, lastname TEXT, email TEXT, celular TEXT)',
      
    );
    print('[DBHelper] _createTableEst: Success');
  }
  
  void saveEst(String name, String lastname, String email, String celular) async {
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawInsert(
        'INSERT INTO Student(name, lastname, email, celular) VALUES(\'$name\', \'$lastname\', \'$email\', \'$celular\')',
      );
    });
    print(
        '[DBHelper] saveStudent: Success | $name, $lastname');    
  }

  
  removeEst(String name) async {
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawDelete('DELETE FROM Student Where name=\'$name\'');
    });
  }

  updateEst(String id,String name, String lastname, String email, String celular) async{
    var dbClient = await db;
    await dbClient.transaction((trans) async{
      return await trans.rawUpdate('UPDATE Student SET name=\'$name\', lastname=\'$lastname\', email=\'$email\', celular=\'$celular\' WHERE id =\'$id\'');
    });
    print(
        '[DBHelper] updateUser: Success | $name, $lastname, $email, $celular');
      
  }

  

  Future<List<Student>> listEst() async {
    var dbClient = await db;
    final List<Student> studentList = List();
    List<Map> queryList = await dbClient.rawQuery(
      'SELECT * FROM Student ',
    );
    if (queryList != null && queryList.length > 0) {
      for (int i = 0; i < queryList.length; i++) {
        studentList.add(Student(
          queryList[i]['id'].toString(),
          queryList[i]['name'],
          queryList[i]['lastname'],
          queryList[i]['email'],
          queryList[i]['celular'],
        ));
      }
    }
    print(studentList);
    return studentList;
  }

}