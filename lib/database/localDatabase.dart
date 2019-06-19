import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UserInfo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE UserInfo ("
          "uid TEXT PRIMARY KEY,"
          "name TEXT,"
          "username TEXT,"
          "contactNumber TEXT,"
          "email TEXT,"
          "profilePictureURL TEXT,"
          "loginProvider TEXT,"
          "dateOfBirth TEXT,"
          "gender TEXT,"
          "instagramUserName TEXT,"
          "createdAt TEXT,"
          "isEmailVerified TEXT"
          ")");
    });
  }
}
