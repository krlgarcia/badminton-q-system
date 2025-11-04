class UserSettings {
  String courtName;
  double courtRate;
  double shuttleCockPrice;
  bool divideCourtEqually;

  UserSettings({
    required this.courtName,
    required this.courtRate,
    required this.shuttleCockPrice,
    required this.divideCourtEqually,
  });

  UserSettings copyWith({
    String? courtName,
    double? courtRate,
    double? shuttleCockPrice,
    bool? divideCourtEqually,
  }) {
    return UserSettings(
      courtName: courtName ?? this.courtName,
      courtRate: courtRate ?? this.courtRate,
      shuttleCockPrice: shuttleCockPrice ?? this.shuttleCockPrice,
      divideCourtEqually: divideCourtEqually ?? this.divideCourtEqually,
    );
  }

  // Calculate court rate per game
  double getCourtRatePerGame(int numberOfGames) {
    if (divideCourtEqually) {
      // If dividing equally, return the hourly rate
      // (will be divided among players later)
      return courtRate;
    } else {
      // If not dividing equally, calculate per game
      // Assuming average game duration
      if (numberOfGames > 0) {
        return courtRate / numberOfGames;
      }
      return courtRate;
    }
  }

  // Calculate cost per player for court
  double getCourtCostPerPlayer(int numberOfPlayers) {
    if (numberOfPlayers > 0) {
      return courtRate / numberOfPlayers;
    }
    return courtRate;
  }

  // Calculate shuttle cock cost per player
  double getShuttleCockCostPerPlayer(int numberOfShuttleCocks, int numberOfPlayers) {
    if (numberOfPlayers > 0) {
      return (shuttleCockPrice * numberOfShuttleCocks) / numberOfPlayers;
    }
    return shuttleCockPrice * numberOfShuttleCocks;
  }
}
