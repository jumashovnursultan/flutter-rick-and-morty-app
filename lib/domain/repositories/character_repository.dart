import '../entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters({required int page});
  Future<List<Character>> getCachedCharacters();
  Future<List<Character>> getFavoriteCharacters();
  Future<void> addToFavorites(Character character);
  Future<void> removeFromFavorites(int characterId);
  Future<bool> isFavorite(int characterId);
}
