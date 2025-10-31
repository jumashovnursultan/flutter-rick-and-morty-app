import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rick_and_morty_app/domain/usecases/get_cached_characters.dart';
import 'package:rick_and_morty_app/domain/usecases/get_characters.dart';
import 'package:rick_and_morty_app/domain/usecases/get_favorite_characters.dart';
import 'package:rick_and_morty_app/domain/usecases/toggle_favorite.dart';
import '../../domain/entities/character.dart';
import 'dependencies_provider.dart';

class CharactersState {
  final List<Character> characters;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;

  const CharactersState({
    required this.characters,
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
  });

  CharactersState copyWith({
    List<Character>? characters,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
  }) {
    return CharactersState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

final allCharactersProvider =
    StateNotifierProvider<AllCharactersNotifier, CharactersState>((ref) {
      final getCharacters = ref.watch(getCharactersUseCaseProvider);
      final getCachedCharacters = ref.watch(getCachedCharactersUseCaseProvider);
      return AllCharactersNotifier(getCharacters, getCachedCharacters);
    });

class AllCharactersNotifier extends StateNotifier<CharactersState> {
  final GetCharacters _getCharacters;
  final GetCachedCharacters _getCachedCharacters;
  bool _cacheLoaded = false;

  AllCharactersNotifier(this._getCharacters, this._getCachedCharacters)
    : super(const CharactersState(characters: [])) {
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final newCharacters = await _getCharacters(page: state.currentPage);

      if (newCharacters.isEmpty) {
        state = state.copyWith(isLoading: false, hasMore: false);
      } else {
        state = state.copyWith(
          characters: [...state.characters, ...newCharacters],
          currentPage: state.currentPage + 1,
          isLoading: false,
        );
      }
    } catch (e) {
      print('Error loading characters: $e');

      if (!_cacheLoaded && state.characters.isEmpty) {
        try {
          final cachedCharacters = await _getCachedCharacters();
          _cacheLoaded = true;
          state = state.copyWith(
            characters: cachedCharacters,
            isLoading: false,
            hasMore: false,
          );
        } catch (cacheError) {
          print('Error loading cache: $cacheError');
          state = state.copyWith(isLoading: false, hasMore: false);
        }
      } else {
        state = state.copyWith(isLoading: false, hasMore: false);
      }
    }
  }

  void refresh() {
    state = const CharactersState(characters: []);
    _cacheLoaded = false;
    loadCharacters();
  }
}

final favoriteIdsProvider =
    StateNotifierProvider<FavoriteIdsNotifier, Set<int>>((ref) {
      final getFavoriteCharacters = ref.watch(
        getFavoriteCharactersUseCaseProvider,
      );
      final toggleFavorite = ref.watch(toggleFavoriteUseCaseProvider);
      return FavoriteIdsNotifier(getFavoriteCharacters, toggleFavorite);
    });

class FavoriteIdsNotifier extends StateNotifier<Set<int>> {
  final GetFavoriteCharacters _getFavoriteCharacters;
  final ToggleFavorite _toggleFavorite;

  FavoriteIdsNotifier(this._getFavoriteCharacters, this._toggleFavorite)
    : super({}) {
    _loadFavoriteIds();
  }

  Future<void> _loadFavoriteIds() async {
    try {
      final favorites = await _getFavoriteCharacters();
      state = favorites.map((char) => char.id).toSet();
    } catch (e) {
      print('Error loading favorite IDs: $e');
    }
  }

  Future<void> toggle(Character character) async {
    try {
      await _toggleFavorite(character);

      if (state.contains(character.id)) {
        state = {...state}..remove(character.id);
      } else {
        state = {...state, character.id};
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }
}

final charactersWithFavoritesProvider = Provider<List<Character>>((ref) {
  final charactersState = ref.watch(allCharactersProvider);
  final favoriteIds = ref.watch(favoriteIdsProvider);

  return charactersState.characters.map((char) {
    return char.copyWith(isFavorite: favoriteIds.contains(char.id));
  }).toList();
});

final charactersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(allCharactersProvider).isLoading;
});

final charactersHasMoreProvider = Provider<bool>((ref) {
  return ref.watch(allCharactersProvider).hasMore;
});
