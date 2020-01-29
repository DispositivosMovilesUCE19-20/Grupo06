import 'package:optativa_app/com.edu.uce.model/object_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class DBHelper3 {
  static final DBHelper3 _instance = DBHelper3.internal();
  DBHelper3.internal();
  factory DBHelper3() =>
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
    String path = join(documentsDirectory.path, 'objetos.db');
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
      'CREATE TABLE Objeto(id INTEGER, name TEXT, descripcion TEXT, categoria TEXT, foto TEXT)',
      
    );
    print('[DBHelper] _createTablesPhoto: Success');
  }

  Future<Objeto> saveObj(Objeto objeto) async{
      var dbCliente=await db;
      objeto.id = await dbCliente.insert('Objeto', objeto.toJson());
      print('[DBHelper] getFoto: ${objeto.foto}');
      return objeto;
  }

  Objeto objeto = new Objeto(0, 'test', 'test', 'test','test');

    Future<Objeto> saveObjtest(Objeto objeto) async{
      var dbCliente=await db;
      objeto.id = await dbCliente.insert('Objeto', objeto.toJson());
      print('[DBHelper] getFoto: ${objeto.foto}');
      return objeto;
  }

  removeAllPhoto() async {
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawDelete('DELETE FROM Objeto');
    });
  }

  Future<List<Objeto>> getObjeto() async {
    var dbClient = await db;
    List<Objeto> objeto = List();
    List<Map> queryList = await dbClient.query('Objeto',columns: ['id','name','descripcion', 'categoria', 'foto']);
    print('[DBHelper] getPhoto: ${queryList.length} fotos');
    if (queryList != null && queryList.length > 0) {
      for (int i = 0; i < queryList.length; i++) {
        objeto.add(Objeto.fromJsonMap(queryList[i]));
      }
      
      return objeto;
    } else {
      print('[DBHelper] getUser: Foto is null');
      return null;
    }
  }


  Future<List<Objeto>> getUniqueObjeto(String user) async {
    var dbClient = await db;
    List<Objeto> usersList = List();
    List<Map> queryList = await dbClient.rawQuery(
      'SELECT * FROM Objeto WHERE name=\'$user\'',
    );
    print('[DBHelper] getObjetos: ${queryList.length} fotos');
    if (queryList != null && queryList.length > 0) {
      for (int i = 0; i < queryList.length; i++) {
        usersList.add(Objeto(
          queryList[i]['id'],
          queryList[i]['name'],
          queryList[i]['descripcion'],
          queryList[i]['categoria'],
          queryList[i]['foto'],
        ));
      }
      print('[DBHelper] getUser: ${usersList[0].foto}');
      return usersList;
    } else {
      print('[DBHelper] getUser: User is null');
      return null;
    }
  }

  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }
}
