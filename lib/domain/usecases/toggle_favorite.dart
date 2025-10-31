import '../entities/character.dart';
import '../repositories/character_repository.dart';

class ToggleFavorite {
  final CharacterRepository _repository;

  ToggleFavorite(this._repository);

  Future<void> call(Character character) async {
    final isFavorite = await _repository.isFavorite(character.id);

    if (isFavorite) {
      await _repository.removeFromFavorites(character.id);
    } else {
      await _repository.addToFavorites(character);
    }
  }
}
