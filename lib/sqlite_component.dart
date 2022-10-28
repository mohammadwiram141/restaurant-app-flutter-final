import 'package:restaurant/favorite_screen/favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteComponent {
  Future<Database> prepareDatabase() async {
    String table = "CREATE TABLE Favorites ("
        "idRestaurant TEXT PRIMARY KEY, "
        "name TEXT NOT NULL, "
        "pictureId TEXT NOT NULL, "
        "rating INTEGER, "
        "city TEXT NOT NULL)";

    String path = join(await getDatabasesPath(), 'favorite.db');

    return openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(table);
      },
      version: 1,
    );
  }

  Future<void> addToFavorite(Favorite favorite) async {
    final Database db = await prepareDatabase();
    await db.insert("Favorites", favorite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteFavorite(String idRestaurant) async {
    final db = await prepareDatabase();
    try {
      await db.delete("Favorites", where: "idRestaurant = ?", whereArgs: [idRestaurant]);
    } catch (err){
      err.toString();
    }
  }

  Future<List<Favorite>> getAllFavorites() async {
    final db = await prepareDatabase();
    final List<Map<String, Object?>> results =
        await db.query("Favorites", orderBy: "idRestaurant");
    return results.map((e) => Favorite.fromMap(e)).toList();
  }

  Future<bool> getFavoriteById(String idRestaurant) async {
    final db = await prepareDatabase();
    final favorite = await db.query("Favorites", where: "idRestaurant = ?", whereArgs: [idRestaurant]);
    return favorite.isNotEmpty;
  }
}
