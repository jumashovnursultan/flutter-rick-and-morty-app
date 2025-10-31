import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetFavoriteCharacters {
  final CharacterRepository _repository;

  GetFavoriteCharacters(this._repository);

  Future<List<Character>> call() async {
    return await _repository.getFavoriteCharacters();
  }
}
