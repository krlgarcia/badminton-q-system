class CourtSchedule {
  final String courtNumber;
  final DateTime startTime;
  final DateTime endTime;

  CourtSchedule({
    required this.courtNumber,
    required this.startTime,
    required this.endTime,
  });

  CourtSchedule copyWith({
    String? courtNumber,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return CourtSchedule(
      courtNumber: courtNumber ?? this.courtNumber,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  // Get duration in hours
  double getDurationInHours() {
    final difference = endTime.difference(startTime);
    return difference.inMinutes / 60.0;
  }

  // Format time for display
  String getTimeRange() {
    final startFormatted = _formatTime(startTime);
    final endFormatted = _formatTime(endTime);
    return '$startFormatted - $endFormatted';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class Game {
  final String id;
  String title;
  String courtName;
  List<CourtSchedule> schedules;
  double courtRate;
  double shuttleCockPrice;
  bool divideCourtEqually;
  DateTime createdAt;

  Game({
    required this.id,
    required this.title,
    required this.courtName,
    required this.schedules,
    required this.courtRate,
    required this.shuttleCockPrice,
    required this.divideCourtEqually,
    required this.createdAt,
  });

  Game copyWith({
    String? id,
    String? title,
    String? courtName,
    List<CourtSchedule>? schedules,
    double? courtRate,
    double? shuttleCockPrice,
    bool? divideCourtEqually,
    DateTime? createdAt,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      courtName: courtName ?? this.courtName,
      schedules: schedules ?? this.schedules,
      courtRate: courtRate ?? this.courtRate,
      shuttleCockPrice: shuttleCockPrice ?? this.shuttleCockPrice,
      divideCourtEqually: divideCourtEqually ?? this.divideCourtEqually,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get the display title
  String getDisplayTitle() {
    if (title.trim().isEmpty && schedules.isNotEmpty) {
      return _formatDate(schedules.first.startTime);
    }
    return title;
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Calculate total duration across all schedules
  double getTotalDurationInHours() {
    double total = 0;
    for (var schedule in schedules) {
      total += schedule.getDurationInHours();
    }
    return total;
  }

  // Calculate total court cost
  double getTotalCourtCost() {
    return courtRate * getTotalDurationInHours();
  }
}
