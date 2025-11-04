import '../models/game.dart';

class GameService {
  // Static list to store games
  static final List<Game> _games = [];

  // Get a copy of all games
  List<Game> getGames() {
    return List.from(_games);
  }

  void addGame(Game game) {
    _games.add(game);
  }

  void updateGame(String id, Game updatedGame) {
    for (int i = 0; i < _games.length; i++) {
      if (_games[i].id == id) {
        _games[i] = updatedGame;
        break;
      }
    }
  }

  void deleteGame(String id) {
    _games.removeWhere((game) {
      return game.id == id;
    });
  }

  Game? getGame(String id) {
    for (Game game in _games) {
      if (game.id == id) {
        return game;
      }
    }
    return null;
  }

  List<Game> searchGames(String query) {
    if (query.isEmpty) {
      return getGames();
    }
    
    final lowercaseQuery = query.toLowerCase();
    List<Game> results = [];
    
    for (Game game in _games) {
      bool matchesTitle = game.getDisplayTitle().toLowerCase().contains(lowercaseQuery);
      bool matchesCourtName = game.courtName.toLowerCase().contains(lowercaseQuery);
      
      if (matchesTitle || matchesCourtName) {
        results.add(game);
      }
    }
    
    return results;
  }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
