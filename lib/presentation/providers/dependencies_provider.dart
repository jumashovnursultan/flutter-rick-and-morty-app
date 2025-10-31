import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/character_local_datasource.dart';
import '../../data/datasources/local/database.dart';
import '../../data/datasources/remote/character_remote_datasource.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/usecases/get_characters.dart';
import '../../domain/usecases/get_cached_characters.dart';
import '../../domain/usecases/get_favorite_characters.dart';
import '../../domain/usecases/toggle_favorite.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final remoteDataSourceProvider = Provider<CharacterRemoteDataSource>((ref) {
  return CharacterRemoteDataSource();
});

final localDataSourceProvider = Provider<CharacterLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return CharacterLocalDataSource(database);
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);

  return CharacterRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// useCases
final getCharactersUseCaseProvider = Provider<GetCharacters>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return GetCharacters(repository);
});

final getCachedCharactersUseCaseProvider = Provider<GetCachedCharacters>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return GetCachedCharacters(repository);
});

final getFavoriteCharactersUseCaseProvider = Provider<GetFavoriteCharacters>((
  ref,
) {
  final repository = ref.watch(characterRepositoryProvider);
  return GetFavoriteCharacters(repository);
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavorite>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return ToggleFavorite(repository);
});
