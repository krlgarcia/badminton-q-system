import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';
import 'add_player_screen.dart';
import 'edit_player_screen.dart';

class AllPlayersScreen extends StatefulWidget {
  const AllPlayersScreen({super.key});

  @override
  State<AllPlayersScreen> createState() {
    return _AllPlayersScreenState();
  }
}

class _AllPlayersScreenState extends State<AllPlayersScreen> {
  final _playerService = PlayerService();

  void _refreshPlayerList() {
    setState(() {});
  }

  void _navigateToAddPlayer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPlayerScreen(),
      ),
    );
    
    if (result == true) {
      _refreshPlayerList();
    }
  }

  void _navigateToEditPlayer(Player player) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlayerScreen(player: player),
      ),
    );
    
    if (result == true) {
      _refreshPlayerList();
    }
  }

  void _deletePlayer(Player player) {
    _playerService.deletePlayer(player.id);
    _refreshPlayerList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player.nickname} has been deleted'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = _playerService.getPlayers();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Players'),
      ),
      body: players.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No players added yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return Dismissible(
                  key: ValueKey(player.id),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(player.nickname.isNotEmpty ? player.nickname[0].toUpperCase() : '?'),
                    ),
                    title: Text(player.nickname),
                    subtitle: Text('${player.fullName} - ${player.level.displayText}'),
                    onTap: () => _navigateToEditPlayer(player),
                  ),
                  onDismissed: (direction) {
                    _deletePlayer(player);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPlayer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
