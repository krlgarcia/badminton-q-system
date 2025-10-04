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
  final LevelCategory category;
  final LevelStrength minStrength;
  final LevelStrength maxStrength;

  BadmintonLevel({
    required this.category,
    required this.minStrength,
    required this.maxStrength,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category.index,
      'minStrength': minStrength.index,
      'maxStrength': maxStrength.index,
    };
  }

  factory BadmintonLevel.fromJson(Map<String, dynamic> json) {
    return BadmintonLevel(
      category: LevelCategory.values[json['category']],
      minStrength: LevelStrength.values[json['minStrength']],
      maxStrength: LevelStrength.values[json['maxStrength']],
    );
  }

  String get displayText {
    String categoryText = _getCategoryDisplayText(category);
    String strengthText = _getStrengthRangeText();
    return '$categoryText ($strengthText)';
  }

  String _getCategoryDisplayText(LevelCategory category) {
    switch (category) {
      case LevelCategory.beginner:
        return 'Beginner';
      case LevelCategory.intermediate:
        return 'Intermediate';
      case LevelCategory.levelG:
        return 'Level G';
      case LevelCategory.levelF:
        return 'Level F';
      case LevelCategory.levelE:
        return 'Level E';
      case LevelCategory.levelD:
        return 'Level D';
      case LevelCategory.openPlayer:
        return 'Open Player';
    }
  }

  String _getStrengthRangeText() {
    if (minStrength == maxStrength) {
      return _getStrengthText(minStrength);
    } else {
      return '${_getStrengthText(minStrength)} - ${_getStrengthText(maxStrength)}';
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