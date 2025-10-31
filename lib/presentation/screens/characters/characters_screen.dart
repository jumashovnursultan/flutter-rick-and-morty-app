import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/character_card.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(allCharactersProvider.notifier).loadCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final characters = ref.watch(charactersWithFavoritesProvider);
    final isLoading = ref.watch(charactersLoadingProvider);
    final hasMore = ref.watch(charactersHasMoreProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: characters.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : characters.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'No characters found',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(allCharactersProvider.notifier).refresh();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async =>
                  ref.read(allCharactersProvider.notifier).refresh(),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: characters.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == characters.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final character = characters[index];
                  return CharacterCard(
                    character: character,
                    onFavoritePressed: () {
                      ref.read(favoriteIdsProvider.notifier).toggle(character);
                    },
                  );
                },
              ),
            ),
    );
  }
}
