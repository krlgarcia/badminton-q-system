import 'package:flutter/material.dart';
import 'add_game_screen.dart';
import 'view_game_screen.dart';
import '../services/game_service.dart';
import '../models/game.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() {
    return _GamesScreenState();
  }
}

class _GamesScreenState extends State<GamesScreen> {
  final _gameService = GameService();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadGames() {
    setState(() {});
  }

  void _navigateToAddGame() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddGameScreen();
        },
      ),
    );

    if (result == true) {
      _loadGames();
    }
  }

  void _deleteGame(Game game) {
    _gameService.deleteGame(game.id);
    setState(() {
      _loadGames();
    });
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getGameTitle(Game game) {
    if (game.title.isNotEmpty) {
      return game.title;
    }
    if (game.schedules.isNotEmpty) {
      return 'Game ${_formatDate(game.schedules.first.startTime)}';
    }
    return 'Game';
  }

  List<Game> _filterGames(List<Game> games) {
    if (_searchController.text.isEmpty) {
      return games;
    }
    
    final query = _searchController.text.toLowerCase();
    return games.where((game) {
      final matchesTitle = _getGameTitle(game).toLowerCase().contains(query);
      final matchesCourtName = game.courtName.toLowerCase().contains(query);
      return matchesTitle || matchesCourtName;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allGames = _gameService.getGames();
    final filteredGames = _filterGames(allGames);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Games'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddGame,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or court...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          // Games List
          Expanded(
            child: filteredGames.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchController.text.isEmpty
                              ? Icons.sports_tennis
                              : Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No games yet'
                              : 'No games found',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];
                      return Dismissible(
                        key: ValueKey(game.id),
                        confirmDismiss: (direction) async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Game'),
                                content: Text(
                                  'Are you sure you want to delete this game?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                          return shouldDelete ?? false;
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(_getGameTitle(game)),
                          subtitle: Text(game.courtName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ViewGameScreen(game: game);
                                },
                              ),
                            );
                          },
                        ),
                        onDismissed: (direction) {
                          _deleteGame(game);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
