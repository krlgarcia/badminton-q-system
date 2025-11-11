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

  @override
  Widget build(BuildContext context) {
    final games = _gameService.getGames();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Games'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddGame,
        child: const Icon(Icons.add),
      ),
      body: games.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_tennis, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No games yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
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
    );
  }
}
