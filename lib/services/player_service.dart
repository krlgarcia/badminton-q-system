import '../models/player.dart';

class PlayerService {
  // Simple list to store players - no singleton pattern
  static final List<Player> _players = [];

  // Get a copy of all players
  List<Player> getPlayers() {
    return List.from(_players);
  }

  void addPlayer(Player player) {
    _players.add(player);
  }

  void updatePlayer(String id, Player updatedPlayer) {
    // Find the player by id and update it
    for (int i = 0; i < _players.length; i++) {
      if (_players[i].id == id) {
        _players[i] = updatedPlayer;
        break;
      }
    }
  }

  void deletePlayer(String id) {
    // Remove the player with the matching id
    _players.removeWhere((player) {
      return player.id == id;
    });
  }

  Player? getPlayer(String id) {
    // Find and return the player with matching id
    for (Player player in _players) {
      if (player.id == id) {
        return player;
      }
    }
    return null;
  }

  List<Player> searchPlayers(String query) {
    if (query.isEmpty) {
      return getPlayers();
    }
    
    final lowercaseQuery = query.toLowerCase();
    List<Player> results = [];
    
    for (Player player in _players) {
      bool matchesNickname = player.nickname.toLowerCase().contains(lowercaseQuery);
      bool matchesFullName = player.fullName.toLowerCase().contains(lowercaseQuery);
      
      if (matchesNickname || matchesFullName) {
        results.add(player);
      }
    }
    
    return results;
  }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}