import '../models/player.dart';
import '../services/player_service.dart';

class SampleDataInitializer {
  static void initializeSampleData() {
    final playerService = PlayerService();
    
    // Only add sample data if no players exist
    if (playerService.players.isEmpty) {
      final samplePlayers = [
        Player(
          id: '1',
          nickname: 'Ace',
          fullName: 'Alexander Chen',
          contactNumber: '+1-555-0101',
          email: 'alex.chen@email.com',
          address: '123 Sports Avenue, City Center, State 12345',
          remarks: 'Very consistent player, good at doubles',
          level: BadmintonLevel(
            category: LevelCategory.intermediate,
            minStrength: LevelStrength.mid,
            maxStrength: LevelStrength.strong,
          ),
        ),
        Player(
          id: '2',
          nickname: 'Smash',
          fullName: 'Sarah Martinez',
          contactNumber: '+1-555-0202',
          email: 'sarah.martinez@email.com',
          address: '456 Court Street, Downtown, State 12345',
          remarks: 'Powerful smashes, prefers singles matches',
          level: BadmintonLevel(
            category: LevelCategory.levelF,
            minStrength: LevelStrength.weak,
            maxStrength: LevelStrength.mid,
          ),
        ),
        Player(
          id: '3',
          nickname: 'Flash',
          fullName: 'Michael Wong',
          contactNumber: '+1-555-0303',
          email: 'mike.wong@email.com',
          address: '789 Racket Road, Sports District, State 12345',
          remarks: 'Quick reflexes, excellent net play',
          level: BadmintonLevel(
            category: LevelCategory.levelE,
            minStrength: LevelStrength.mid,
            maxStrength: LevelStrength.strong,
          ),
        ),
        Player(
          id: '4',
          nickname: 'Rookie',
          fullName: 'Emma Thompson',
          contactNumber: '+1-555-0404',
          email: 'emma.thompson@email.com',
          address: '321 Newcomer Lane, Suburb, State 12345',
          remarks: 'New to badminton but very enthusiastic',
          level: BadmintonLevel(
            category: LevelCategory.beginner,
            minStrength: LevelStrength.weak,
            maxStrength: LevelStrength.weak,
          ),
        ),
        Player(
          id: '5',
          nickname: 'Pro',
          fullName: 'David Kim',
          contactNumber: '+1-555-0505',
          email: 'david.kim@email.com',
          address: '654 Championship Drive, Elite Area, State 12345',
          remarks: 'Tournament player, available for coaching',
          level: BadmintonLevel(
            category: LevelCategory.openPlayer,
            minStrength: LevelStrength.strong,
            maxStrength: LevelStrength.strong,
          ),
        ),
      ];

      for (final player in samplePlayers) {
        playerService.addPlayer(player);
      }
    }
  }
}