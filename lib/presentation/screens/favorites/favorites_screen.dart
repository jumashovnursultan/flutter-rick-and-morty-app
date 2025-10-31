import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/favorites_screen_provider.dart';
import '../../widgets/character_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(sortedFavoritesProvider);
    final sortType = ref.watch(sortTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          PopupMenuButton<SortType>(
            icon: const Icon(Icons.sort),
            initialValue: sortType,
            onSelected: (type) {
              ref.read(sortTypeProvider.notifier).state = type;
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: SortType.name, child: Text('Sort by Name')),
              PopupMenuItem(
                value: SortType.status,
                child: Text('Sort by Status'),
              ),
              PopupMenuItem(
                value: SortType.species,
                child: Text('Sort by Species'),
              ),
            ],
          ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add characters to favorites by tapping the star',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final character = favorites[index];
                return CharacterCard(
                  character: character,
                  onFavoritePressed: () {
                    ref.read(favoriteIdsProvider.notifier).toggle(character);
                  },
                );
              },
            ),
    );
  }
}
