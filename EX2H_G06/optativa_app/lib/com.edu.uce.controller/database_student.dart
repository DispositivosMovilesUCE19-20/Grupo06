import 'package:optativa_app/com.edu.uce.model/student_model.dart';
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
      'CREATE TABLE Student(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, lastname TEXT, email TEXT, celular TEXT, genero TEXT, fecha TEXT, foto TEXT, becado TEXT)',
      
    );
    print('[DBHelper] _createTableEst: Success');
  }
  
  void saveEst(String name, String lastname, String email, String celular, String genero, String fecha, String foto, String becado) async {
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawInsert(
        'INSERT INTO Student(name, lastname, email, celular, genero, fecha, foto, becado) VALUES(\'$name\', \'$lastname\', \'$email\', \'$celular\', \'$genero\', \'$fecha\', \'$foto\', \'$becado\')',
      );
    });
    print(
        '[DBHelper] saveStudent: Success | $name, $lastname');    
  }

  
  removeEst(String name,String) async {
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawDelete('DELETE FROM Student Where name=\'$name\'And becado=');
    });
  }

  updateEst(String id,String name, String lastname, String email, String celular, String genero, String fecha, String foto) async{
    var dbClient = await db;
    await dbClient.transaction((trans) async{
      return await trans.rawUpdate('UPDATE Student SET name=\'$name\', lastname=\'$lastname\', email=\'$email\', celular=\'$celular\', genero=\'$genero\', fecha=\'$fecha\', foto=\'$foto\' WHERE id =\'$id\'');
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
          queryList[i]['genero'],
          queryList[i]['fecha'],
          queryList[i]['foto'],
          queryList[i]['becado']
        ));
      }
    }
    print(studentList);
    return studentList;
  }

}