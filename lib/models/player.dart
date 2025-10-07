class Player {
  final String id;
  String nickname;
  String fullName;
  String contactNumber;
  String email;
  String address;
  String remarks;
  BadmintonLevel level;

  Player({
    required this.id,
    required this.nickname,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.remarks,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'fullName': fullName,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'remarks': remarks,
      'level': level.toJson(),
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      nickname: json['nickname'],
      fullName: json['fullName'],
      contactNumber: json['contactNumber'],
      email: json['email'],
      address: json['address'],
      remarks: json['remarks'],
      level: BadmintonLevel.fromJson(json['level']),
    );
  }

  Player copyWith({
    String? id,
    String? nickname,
    String? fullName,
    String? contactNumber,
    String? email,
    String? address,
    String? remarks,
    BadmintonLevel? level,
  }) {
    return Player(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      remarks: remarks ?? this.remarks,
      level: level ?? this.level,
    );
  }
}

enum LevelCategory { 
  beginner, 
  intermediate, 
  levelG, 
  levelF, 
  levelE, 
  levelD, 
  openPlayer 
}

enum LevelStrength { weak, mid, strong }

class BadmintonLevel {
  final LevelCategory minCategory;
  final LevelStrength minStrength;
  final LevelCategory maxCategory;
  final LevelStrength maxStrength;

  BadmintonLevel({
    required this.minCategory,
    required this.minStrength,
    required this.maxCategory,
    required this.maxStrength,
  });

  Map<String, dynamic> toJson() {
    return {
      'minCategory': minCategory.index,
      'minStrength': minStrength.index,
      'maxCategory': maxCategory.index,
      'maxStrength': maxStrength.index,
    };
  }

  factory BadmintonLevel.fromJson(Map<String, dynamic> json) {
    return BadmintonLevel(
      minCategory: LevelCategory.values[json['minCategory']],
      minStrength: LevelStrength.values[json['minStrength']],
      maxCategory: LevelCategory.values[json['maxCategory']],
      maxStrength: LevelStrength.values[json['maxStrength']],
    );
  }

  String get displayText {
    // Handle Open Player specially - no strength variations
    if (minCategory == LevelCategory.openPlayer && maxCategory == LevelCategory.openPlayer) {
      return 'Open';
    }
    
    if (minCategory == maxCategory) {
      // Same category range
      if (minStrength == maxStrength) {
        // Single level
        return '${_getStrengthText(minStrength)} ${_getCategoryShortText(minCategory)}';
      } else {
        // Range within same category
        return '${_getStrengthText(minStrength)} ${_getCategoryShortText(minCategory)} — ${_getStrengthText(maxStrength)} ${_getCategoryShortText(maxCategory)}';
      }
    } else {
      // Cross-category range
      String minText = minCategory == LevelCategory.openPlayer ? 'Open' : '${_getStrengthText(minStrength)} ${_getCategoryShortText(minCategory)}';
      String maxText = maxCategory == LevelCategory.openPlayer ? 'Open' : '${_getStrengthText(maxStrength)} ${_getCategoryShortText(maxCategory)}';
      return '$minText — $maxText';
    }
  }

  String _getCategoryShortText(LevelCategory category) {
    switch (category) {
      case LevelCategory.beginner:
        return 'B';
      case LevelCategory.intermediate:
        return 'I';
      case LevelCategory.levelG:
        return 'G';
      case LevelCategory.levelF:
        return 'F';
      case LevelCategory.levelE:
        return 'E';
      case LevelCategory.levelD:
        return 'D';
      case LevelCategory.openPlayer:
        return 'O';
    }
  }

  String _getStrengthText(LevelStrength strength) {
    switch (strength) {
      case LevelStrength.weak:
        return 'Weak';
      case LevelStrength.mid:
        return 'Mid';
      case LevelStrength.strong:
        return 'Strong';
    }
  }
}