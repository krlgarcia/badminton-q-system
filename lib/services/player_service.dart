import '../models/player.dart';

class PlayerService {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal();

  final List<Player> _players = [];

  List<Player> get players => List.unmodifiable(_players);

  void addPlayer(Player player) {
    _players.add(player);
  }

  void updatePlayer(String id, Player updatedPlayer) {
    final index = _players.indexWhere((player) => player.id == id);
    if (index != -1) {
      _players[index] = updatedPlayer;
    }
  }

  void deletePlayer(String id) {
    _players.removeWhere((player) => player.id == id);
  }

  Player? getPlayer(String id) {
    try {
      return _players.firstWhere((player) => player.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Player> searchPlayers(String query) {
    if (query.isEmpty) return players;
    
    final lowercaseQuery = query.toLowerCase();
    return _players.where((player) {
      return player.nickname.toLowerCase().contains(lowercaseQuery) ||
             player.fullName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}