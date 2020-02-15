import 'Note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;  //singleton method runs only once
  static Database _database;    //singleton

  String noteTable = 'note_table';
  String colID = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();     //named constructor
  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance(); //it means if there are no data existence then create once
    }
    return _databaseHelper;
  }
//custom getter for database just initialise database if exists
  Future<Database> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database>initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();   //to know in which directory it is installed in mobile 
    String path = directory.path + 'details.db';

    var detailDatabase = await openDatabase(
      path, version: 1, onCreate: _createDb     //createDb is method
      );
      return detailDatabase;
  }

  void _createDb(Database db, int newVersion)async {
    await db.execute(
      'CREATE TABLE $noteTable($colID INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

//we need to fetch operation which is responsible for getting all the note object from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');  //ASC = ascending order
   // var result = await db.rawQuery('SELECT * from $noteTable order by $colPriority ASC');    this and above method are same
   return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());    //we are taking help from Map in Note.dart file
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
    where: '$colID = ?', whereArgs: [note.id]);    //you can use the raw query
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable where $colID = $id');
    return result;
  }

//counting how many values are inside database
Future<int> getCount() async {
  Database db = await this.database;
  List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
  int result = Sqflite.firstIntValue(x);
  return result;
}

//finally we are converting everything from notelist to maplist bcoz maplist are displayed in UI
Future<List<Note>> getNoteList() async{
  var noteMapList = await this.getNoteMapList();
  int count = noteMapList.length;   //to count the number of entries in the list and then loop through it

  List<Note> noteList = List<Note>();
  //looping through and call note.frommapobject method from Note.dart file
  for(var i=0; i<count; i++){
    noteList.add(Note.fromMapObject(noteMapList[i]));
  }
  return noteList;
}


}