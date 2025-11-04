import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';
import '../widgets/badminton_level_slider.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  State<AddPlayerScreen> createState() {
    return _AddPlayerScreenState();
  }
}

class _LevelPosition {
  final LevelCategory category;
  final LevelStrength strength;

  _LevelPosition(this.category, this.strength);
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _playerService = PlayerService();
  
  final _nicknameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarksController = TextEditingController();
  
  LevelCategory _selectedMinCategory = LevelCategory.beginner;
  LevelStrength _selectedMinStrength = LevelStrength.weak;
  LevelCategory _selectedMaxCategory = LevelCategory.beginner;
  LevelStrength _selectedMaxStrength = LevelStrength.weak;

  RangeValues _selectedLevelRange = const RangeValues(0, 0);

  @override
  void dispose() {
    _nicknameController.dispose();
    _fullNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  _LevelPosition _getLevelFromPosition(double position) {
    final pos = position.round();
    
    if (pos == 0) return _LevelPosition(LevelCategory.beginner, LevelStrength.weak);
    if (pos == 1) return _LevelPosition(LevelCategory.beginner, LevelStrength.mid);
    if (pos == 2) return _LevelPosition(LevelCategory.beginner, LevelStrength.strong);
    
    if (pos == 3) return _LevelPosition(LevelCategory.intermediate, LevelStrength.weak);
    if (pos == 4) return _LevelPosition(LevelCategory.intermediate, LevelStrength.mid);
    if (pos == 5) return _LevelPosition(LevelCategory.intermediate, LevelStrength.strong);
    
    if (pos == 6) return _LevelPosition(LevelCategory.levelG, LevelStrength.weak);
    if (pos == 7) return _LevelPosition(LevelCategory.levelG, LevelStrength.mid);
    if (pos == 8) return _LevelPosition(LevelCategory.levelG, LevelStrength.strong);
    
    if (pos == 9) return _LevelPosition(LevelCategory.levelF, LevelStrength.weak);
    if (pos == 10) return _LevelPosition(LevelCategory.levelF, LevelStrength.mid);
    if (pos == 11) return _LevelPosition(LevelCategory.levelF, LevelStrength.strong);
    
    if (pos == 12) return _LevelPosition(LevelCategory.levelE, LevelStrength.weak);
    if (pos == 13) return _LevelPosition(LevelCategory.levelE, LevelStrength.mid);
    if (pos == 14) return _LevelPosition(LevelCategory.levelE, LevelStrength.strong);
    
    if (pos == 15) return _LevelPosition(LevelCategory.levelD, LevelStrength.weak);
    if (pos == 16) return _LevelPosition(LevelCategory.levelD, LevelStrength.mid);
    if (pos == 17) return _LevelPosition(LevelCategory.levelD, LevelStrength.strong);
    
    return _LevelPosition(LevelCategory.openPlayer, LevelStrength.weak);
  }

  void _updateSelectedLevelFromRange() {
    final minLevel = _getLevelFromPosition(_selectedLevelRange.start);
    final maxLevel = _getLevelFromPosition(_selectedLevelRange.end);
    
    setState(() {
      _selectedMinCategory = minLevel.category;
      _selectedMinStrength = minLevel.strength;
      _selectedMaxCategory = maxLevel.category;
      _selectedMaxStrength = maxLevel.strength;
    });
  }

  void _savePlayer() {
    if (_formKey.currentState!.validate()) {
      final player = Player(
        id: _playerService.generateId(),
        nickname: _nicknameController.text,
        fullName: _fullNameController.text,
        contactNumber: _contactController.text,
        email: _emailController.text,
        address: _addressController.text,
        remarks: _remarksController.text,
        level: BadmintonLevel(
          minCategory: _selectedMinCategory,
          minStrength: _selectedMinStrength,
          maxCategory: _selectedMaxCategory,
          maxStrength: _selectedMaxStrength,
        ),
      );

      _playerService.addPlayer(player);
      
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Player'),
        actions: [
          TextButton(
            onPressed: _savePlayer,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a nickname';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  icon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  icon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  icon: Icon(Icons.location_on),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  icon: Icon(Icons.notes),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              const Text(
                'Badminton Level',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              BadmintonLevelSlider(
                initialRange: _selectedLevelRange,
                onChanged: (RangeValues range) {
                  setState(() {
                    _selectedLevelRange = range;
                    _updateSelectedLevelFromRange();
                  });
                },
              ),
              const SizedBox(height: 10),

              Text(
                BadmintonLevel(
                  minCategory: _selectedMinCategory,
                  minStrength: _selectedMinStrength,
                  maxCategory: _selectedMaxCategory,
                  maxStrength: _selectedMaxStrength,
                ).displayText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
