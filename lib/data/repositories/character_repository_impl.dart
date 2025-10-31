import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/local/character_local_datasource.dart';
import '../datasources/remote/character_remote_datasource.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource _remoteDataSource;
  final CharacterLocalDataSource _localDataSource;

  CharacterRepositoryImpl({
    required CharacterRemoteDataSource remoteDataSource,
    required CharacterLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<List<Character>> getCharacters({required int page}) async {
    final characters = await _remoteDataSource.getCharacters(page: page);

    await _localDataSource.cacheCharacters(characters);

    final favoriteIds = <int>[];
    for (var char in characters) {
      if (await _localDataSource.isFavorite(char.id)) {
        favoriteIds.add(char.id);
      }
    }

    return characters.map((char) {
      return char.toEntity(isFavorite: favoriteIds.contains(char.id));
    }).toList();
  }

  @override
  Future<List<Character>> getCachedCharacters() async {
    return await _localDataSource.getCachedCharacters();
  }

  @override
  Future<List<Character>> getFavoriteCharacters() async {
    return await _localDataSource.getFavoriteCharacters();
  }

  @override
  Future<void> addToFavorites(Character character) async {
    await _localDataSource.addToFavorites(character.id);
  }

  @override
  Future<void> removeFromFavorites(int characterId) async {
    await _localDataSource.removeFromFavorites(characterId);
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    return await _localDataSource.isFavorite(characterId);
  }
}
