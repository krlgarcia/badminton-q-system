import 'package:flutter/material.dart';

class BadmintonLevelSlider extends StatelessWidget {
  final RangeValues initialRange;
  final void Function(RangeValues) onChanged;

  const BadmintonLevelSlider({
    super.key,
    required this.initialRange,
    required this.onChanged,
  });

  String _getLabelForPosition(double position) {
    final pos = position.round();
    
    if (pos == 0) return 'Weak B';
    if (pos == 1) return 'Mid B';
    if (pos == 2) return 'Strong B';
    
    if (pos == 3) return 'Weak I';
    if (pos == 4) return 'Mid I';
    if (pos == 5) return 'Strong I';
    
    if (pos == 6) return 'Weak G';
    if (pos == 7) return 'Mid G';
    if (pos == 8) return 'Strong G';
    
    if (pos == 9) return 'Weak F';
    if (pos == 10) return 'Mid F';
    if (pos == 11) return 'Strong F';
    
    if (pos == 12) return 'Weak E';
    if (pos == 13) return 'Mid E';
    if (pos == 14) return 'Strong E';
    
    if (pos == 15) return 'Weak D';
    if (pos == 16) return 'Mid D';
    if (pos == 17) return 'Strong D';
    
    return 'Open';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RangeSlider(
          values: initialRange,
          min: 0,
          max: 18,
          divisions: 18,
          labels: RangeLabels(
            _getLabelForPosition(initialRange.start),
            _getLabelForPosition(initialRange.end),
          ),
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getLabelForPosition(initialRange.start),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                _getLabelForPosition(initialRange.end),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
