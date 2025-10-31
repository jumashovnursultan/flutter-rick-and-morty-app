import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/constants/app_constants.dart';

part 'database.g.dart';

class Characters extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  TextColumn get species => text()();
  TextColumn get type => text()();
  TextColumn get gender => text()();
  TextColumn get locationName => text()();
  TextColumn get originName => text()();
  TextColumn get image => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Favorites extends Table {
  IntColumn get characterId => integer()();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {characterId};
}

@DriftDatabase(tables: [Characters, Favorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Character>> getAllCachedCharacters() => select(characters).get();

  Future<void> insertCharacter(CharactersCompanion character) =>
      into(characters).insert(character, mode: InsertMode.replace);

  Future<void> insertCharacters(
    List<CharactersCompanion> charactersList,
  ) async {
    await batch((batch) {
      batch.insertAll(characters, charactersList, mode: InsertMode.replace);
    });
  }

  Future<List<int>> getFavoriteIds() async {
    final favorites = await select(this.favorites).get();
    return favorites.map((f) => f.characterId).toList();
  }

  Future<void> addToFavorites(int characterId) {
    return into(favorites).insert(
      FavoritesCompanion.insert(
        characterId: Value(characterId),
        addedAt: DateTime.now(),
      ),
      mode: InsertMode.replace,
    );
  }

  Future<void> removeFromFavorites(int characterId) {
    return (delete(
      favorites,
    )..where((f) => f.characterId.equals(characterId))).go();
  }

  Future<bool> isFavorite(int characterId) async {
    final query = select(favorites)
      ..where((f) => f.characterId.equals(characterId));
    final result = await query.get();
    return result.isNotEmpty;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase(file);
  });
}
