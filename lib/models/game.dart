class CourtSchedule {
  final String courtNumber;
  final DateTime startTime;
  final DateTime endTime;

  CourtSchedule({
    required this.courtNumber,
    required this.startTime,
    required this.endTime,
  });

  double getDurationInHours() {
    final difference = endTime.difference(startTime);
    return difference.inMinutes / 60.0;
  }

  String getTimeRange() {
    final startHour = startTime.hour % 12 == 0 ? 12 : startTime.hour % 12;
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final startPeriod = startTime.hour >= 12 ? 'PM' : 'AM';
    
    final endHour = endTime.hour % 12 == 0 ? 12 : endTime.hour % 12;
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    final endPeriod = endTime.hour >= 12 ? 'PM' : 'AM';
    
    return '$startHour:$startMinute $startPeriod - $endHour:$endMinute $endPeriod';
  }
}

class Game {
  final String id;
  String title;
  String courtName;
  List<CourtSchedule> schedules;
  double courtRate;
  double shuttleCockPrice;
  bool divideCourtRate;
  bool divideShuttleCockPrice;
  DateTime createdAt;

  Game({
    required this.id,
    required this.title,
    required this.courtName,
    required this.schedules,
    required this.courtRate,
    required this.shuttleCockPrice,
    required this.divideCourtRate,
    required this.divideShuttleCockPrice,
    required this.createdAt,
  });

  String getDisplayTitle() {
    if (title.isEmpty && schedules.isNotEmpty) {
      final date = schedules.first.startTime;
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
    return title;
  }

  double getTotalDurationInHours() {
    double total = 0;
    for (var schedule in schedules) {
      total = total + schedule.getDurationInHours();
    }
    return total;
  }

  double getTotalCourtCost() {
    return courtRate * getTotalDurationInHours();
  }
}
