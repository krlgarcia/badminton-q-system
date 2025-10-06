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
          nickname: 'Harriette',
          fullName: 'Harriette Cabigao',
          contactNumber: '+63-987-6543-210',
          email: 'harriette.cabigao@email.com',
          address: 'Laoag, San Fernando City, La Union',
          remarks: 'Very consistent player, good at doubles',
          level: BadmintonLevel(
            minCategory: LevelCategory.intermediate,
            minStrength: LevelStrength.mid,
            maxCategory: LevelCategory.intermediate,
            maxStrength: LevelStrength.strong,
          ),
        ),
        Player(
          id: '2',
          nickname: 'Marcel',
          fullName: 'Marcel Salmorin',
          contactNumber: '+63-987-6543-210',
          email: 'marcel.salmorin@email.com',
          address: 'Baguio City, Benguet',
          remarks: 'Powerful smashes, prefers singles matches',
          level: BadmintonLevel(
            minCategory: LevelCategory.levelF,
            minStrength: LevelStrength.weak,
            maxCategory: LevelCategory.levelF,
            maxStrength: LevelStrength.mid,
          ),
        ),
        Player(
          id: '3',
          nickname: 'Krom',
          fullName: 'Kromyko Cruzado',
          contactNumber: '+63-987-6543-210',
          email: 'kromyko.cruzado@email.com',
          address: 'Angeles City, Pampanga',
          remarks: 'Quick reflexes, excellent net play',
          level: BadmintonLevel(
            minCategory: LevelCategory.intermediate,
            minStrength: LevelStrength.strong,
            maxCategory: LevelCategory.levelE,
            maxStrength: LevelStrength.mid,
          ),
        ),
        Player(
          id: '4',
          nickname: 'Bea',
          fullName: 'Bea Lim',
          contactNumber: '+63-987-6543-210',
          email: 'bea.lim@email.com',
          address: 'Olongapo City, Zambales',
          remarks: 'New to badminton but very enthusiastic',
          level: BadmintonLevel(
            minCategory: LevelCategory.beginner,
            minStrength: LevelStrength.weak,
            maxCategory: LevelCategory.beginner,
            maxStrength: LevelStrength.weak,
          ),
        ),
        Player(
          id: '5',
          nickname: 'Jies',
          fullName: 'Jiescotniel Bacaro',
          contactNumber: '+63-987-6543-210',
          email: 'jiescotniel.bacaro@email.com',
          address: 'Legazpi City, Albay',
          remarks: 'Tournament player, available for coaching',
          level: BadmintonLevel(
            minCategory: LevelCategory.openPlayer,
            minStrength: LevelStrength.strong,
            maxCategory: LevelCategory.openPlayer,
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