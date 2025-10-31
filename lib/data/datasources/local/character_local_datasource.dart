import '../../../domain/entities/character.dart';
import '../../models/character_model.dart';
import 'database.dart' hide Character;
import 'package:drift/drift.dart' as drift;

class CharacterLocalDataSource {
  final AppDatabase _database;

  CharacterLocalDataSource(this._database);

  Future<void> cacheCharacters(List<CharacterModel> characters) async {
    final companions = characters.map((char) {
      return CharactersCompanion(
        id: drift.Value(char.id),
        name: drift.Value(char.name),
        status: drift.Value(char.status),
        species: drift.Value(char.species),
        type: drift.Value(char.type),
        gender: drift.Value(char.gender),
        locationName: drift.Value(char.location.name),
        originName: drift.Value(char.origin.name),
        image: drift.Value(char.image),
        cachedAt: drift.Value(DateTime.now()),
      );
    }).toList();

    await _database.insertCharacters(companions);
  }

  Future<List<Character>> getCachedCharacters() async {
    final cachedChars = await _database.getAllCachedCharacters();
    final favoriteIds = await _database.getFavoriteIds();

    return cachedChars.map((char) {
      return Character(
        id: char.id,
        name: char.name,
        status: char.status,
        species: char.species,
        type: char.type,
        gender: char.gender,
        locationName: char.locationName,
        originName: char.originName,
        image: char.image,
        isFavorite: favoriteIds.contains(char.id),
      );
    }).toList();
  }

  Future<List<Character>> getFavoriteCharacters() async {
    final favoriteIds = await _database.getFavoriteIds();
    final allCached = await _database.getAllCachedCharacters();

    final favorites = allCached
        .where((char) => favoriteIds.contains(char.id))
        .toList();

    return favorites.map((char) {
      return Character(
        id: char.id,
        name: char.name,
        status: char.status,
        species: char.species,
        type: char.type,
        gender: char.gender,
        locationName: char.locationName,
        originName: char.originName,
        image: char.image,
        isFavorite: true,
      );
    }).toList();
  }

  Future<void> addToFavorites(int characterId) async {
    await _database.addToFavorites(characterId);
  }

  Future<void> removeFromFavorites(int characterId) async {
    await _database.removeFromFavorites(characterId);
  }

  Future<bool> isFavorite(int characterId) async {
    return await _database.isFavorite(characterId);
  }
}
