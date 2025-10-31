import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/character.dart';
import 'app_state_provider.dart';

enum SortType { name, status, species }

final sortTypeProvider = StateProvider<SortType>((ref) => SortType.name);

final sortedFavoritesProvider = Provider<List<Character>>((ref) {
  final charactersState = ref.watch(allCharactersProvider);
  final favoriteIds = ref.watch(favoriteIdsProvider);
  final sortType = ref.watch(sortTypeProvider);

  final favorites = charactersState.characters
      .where((char) => favoriteIds.contains(char.id))
      .map((char) => char.copyWith(isFavorite: true))
      .toList();

  return _sortCharacters(favorites, sortType);
});

List<Character> _sortCharacters(List<Character> characters, SortType sortType) {
  final list = List<Character>.from(characters);

  switch (sortType) {
    case SortType.name:
      list.sort((a, b) => a.name.compareTo(b.name));
      break;
    case SortType.status:
      list.sort((a, b) {
        const statusOrder = {'Alive': 0, 'Dead': 1, 'unknown': 2};
        final orderA = statusOrder[a.status] ?? 3;
        final orderB = statusOrder[b.status] ?? 3;
        return orderA.compareTo(orderB);
      });
      break;
    case SortType.species:
      list.sort((a, b) => a.species.compareTo(b.species));
      break;
  }

  return list;
}
