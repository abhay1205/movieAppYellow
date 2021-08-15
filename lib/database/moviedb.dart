
import 'package:movieapp/models/movieModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class MovieDB {

  static final MovieDB instance = MovieDB._init();
  static Database _database;

  MovieDB._init(); 

  Future<Database> get database async {
    if(_database !=null) return _database;
    _database = await _initDB('movie.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final doubleType = 'REAL NOT NULL';
    try {
      await db.execute('''
    CREATE TABLE $tableMovie (
      ${MovieFields.id} $idType,
      ${MovieFields.movieName} $textType,
      ${MovieFields.dirName} $textType,
      ${MovieFields.rating} $doubleType,
      ${MovieFields.filePath} $textType,
      ${MovieFields.time} $textType
    )
    ''');
    print('SUCCESS');
    } catch (e) {
      print(e);
    }
    

  }

  Future<Movie> create(Movie movie) async {
    try {
      final db = await instance.database;
      final id = await db.insert(tableMovie, movie.toJson());
      return movie.copy(id: id);
    } catch (e) {
      print(e);
    }
    
  }

  Future<Movie> readMovie(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableMovie,
      columns: MovieFields.values,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );

    if(maps.isNotEmpty){
      return Movie.fromJson(maps.first);
    }else{
      throw new Exception('ID: $id not found');
    }
  }

  Future<List<Movie>> readAll ()async{
    final db = await instance.database;

    final orderBy = '${MovieFields.time} ASC';
    final result = await db.query(tableMovie, orderBy: orderBy);

    return result.map((json)=> Movie.fromJson(json)).toList();
  }

  Future<int> update(Movie movie) async {
    final db = await instance.database;
    return db.update(tableMovie, movie.toJson(), where: '${MovieFields.id} = ?', whereArgs: [movie.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMovie,
      where: '${MovieFields.id} = ?',
      whereArgs: [id]
    );
  }

  Future close() async { 
    final db = await instance.database;
    db.close();
  }

}