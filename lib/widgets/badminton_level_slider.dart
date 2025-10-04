import 'package:flutter/material.dart';
import '../models/player.dart';

class BadmintonLevelSlider extends StatefulWidget {
  final BadmintonLevel initialLevel;
  final Function(BadmintonLevel) onLevelChanged;

  const BadmintonLevelSlider({
    super.key,
    required this.initialLevel,
    required this.onLevelChanged,
  });

  @override
  State<BadmintonLevelSlider> createState() => _BadmintonLevelSliderState();
}

class _BadmintonLevelSliderState extends State<BadmintonLevelSlider> {
  late LevelCategory selectedCategory;
  late double minValue;
  late double maxValue;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialLevel.category;
    minValue = widget.initialLevel.minStrength.index.toDouble();
    maxValue = widget.initialLevel.maxStrength.index.toDouble();
  }

  void _updateLevel() {
    final level = BadmintonLevel(
      category: selectedCategory,
      minStrength: LevelStrength.values[minValue.round()],
      maxStrength: LevelStrength.values[maxValue.round()],
    );
    widget.onLevelChanged(level);
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

  String _getStrengthText(int index) {
    switch (index) {
      case 0:
        return 'Weak';
      case 1:
        return 'Mid';
      case 2:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Badminton Level',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Category Dropdown
            DropdownButtonFormField<LevelCategory>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Level Category',
                border: OutlineInputBorder(),
              ),
              items: LevelCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(_getCategoryDisplayText(category)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                  _updateLevel();
                }
              },
            ),
            
            const SizedBox(height: 20),
            
            // Strength Range Slider
            const Text(
              'Strength Range',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Text('Weak', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(minValue, maxValue),
                    min: 0,
                    max: 2,
                    divisions: 2,
                    labels: RangeLabels(
                      _getStrengthText(minValue.round()),
                      _getStrengthText(maxValue.round()),
                    ),
                    onChanged: (values) {
                      setState(() {
                        minValue = values.start;
                        maxValue = values.end;
                      });
                      _updateLevel();
                    },
                  ),
                ),
                const Text('Strong', style: TextStyle(fontSize: 12)),
              ],
            ),
            
            // Display current selection
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Selected: ${_getCategoryDisplayText(selectedCategory)} (${_getStrengthText(minValue.round())}${minValue != maxValue ? ' - ${_getStrengthText(maxValue.round())}' : ''})',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}