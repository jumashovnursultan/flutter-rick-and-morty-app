import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/domain/repositories/character_repository.dart';

class GetCachedCharacters {
  final CharacterRepository _repository;

  GetCachedCharacters(this._repository);

  Future<List<Character>> call() async {
    return await _repository.getCachedCharacters();
  }
}
