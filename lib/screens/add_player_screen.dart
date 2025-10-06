import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
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
  
  BadmintonLevel _selectedLevel = BadmintonLevel(
    minCategory: LevelCategory.beginner,
    minStrength: LevelStrength.weak,
    maxCategory: LevelCategory.beginner,
    maxStrength: LevelStrength.weak,
  );
  
  // Range slider values (0-17 scale covering all levels and strengths)
  RangeValues _levelRange = const RangeValues(4, 10);

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

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  void _savePlayer() {
    if (_formKey.currentState!.validate()) {
      final player = Player(
        id: _playerService.generateId(),
        nickname: _nicknameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        contactNumber: _contactController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        remarks: _remarksController.text.trim(),
        level: _selectedLevel,
      );

      _playerService.addPlayer(player);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Player added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, true);
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLevelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Level labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLevelLabel('INTERMEDIATE'),
              _buildLevelLabel('LEVEL G'),
              _buildLevelLabel('LEVEL F'), 
              _buildLevelLabel('LEVEL E'),
              _buildLevelLabel('LEVEL D'),
              _buildLevelLabel('OPEN'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Strength indicators (W M S) under each level
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              // INTERMEDIATE W M S
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['W', 'M', 'S'].map((s) => Text(
                    s,
                    style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                  )).toList(),
                ),
              ),
              // LEVEL G W M S  
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['W', 'M', 'S'].map((s) => Text(
                    s,
                    style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                  )).toList(),
                ),
              ),
              // LEVEL F W M S
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['W', 'M', 'S'].map((s) => Text(
                    s,
                    style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                  )).toList(),
                ),
              ),
              // LEVEL E W M S
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['W', 'M', 'S'].map((s) => Text(
                    s,
                    style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                  )).toList(),
                ),
              ),
              // LEVEL D W M S
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['W', 'M', 'S'].map((s) => Text(
                    s,
                    style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                  )).toList(),
                ),
              ),
              // OPEN (no W M S)
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Range Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.grey[300],
            trackHeight: 6,
            thumbColor: Colors.blue,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayColor: Colors.blue.withAlpha(32),
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: RangeSlider(
            values: _levelRange,
            min: 0,
            max: 17,
            divisions: 17,
            onChanged: (RangeValues values) {
              setState(() {
                _levelRange = values;
                _updateSelectedLevelFromRange(values);
              });
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Selected range indicator  
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            'Selected Range: ${_getRangeLabel(_levelRange.start)} - ${_getRangeLabel(_levelRange.end)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelLabel(String levelName) {
    return Expanded(
      child: Text(
        levelName,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _updateSelectedLevelFromRange(RangeValues values) {
    final startPos = values.start.round();
    final endPos = values.end.round();
    
    // Convert positions to category and strength
    final minLevel = _getLevelFromPosition(startPos);
    final maxLevel = _getLevelFromPosition(endPos);
    
    _selectedLevel = BadmintonLevel(
      minCategory: minLevel.category,
      minStrength: minLevel.strength,
      maxCategory: maxLevel.category,
      maxStrength: maxLevel.strength,
    );
  }

  ({LevelCategory category, LevelStrength strength}) _getLevelFromPosition(int position) {
    if (position <= 2) {
      return (category: LevelCategory.intermediate, strength: LevelStrength.values[position]);
    } else if (position <= 5) {
      return (category: LevelCategory.levelG, strength: LevelStrength.values[position - 3]);
    } else if (position <= 8) {
      return (category: LevelCategory.levelF, strength: LevelStrength.values[position - 6]);
    } else if (position <= 11) {
      return (category: LevelCategory.levelE, strength: LevelStrength.values[position - 9]);
    } else if (position <= 14) {
      return (category: LevelCategory.levelD, strength: LevelStrength.values[position - 12]);
    } else {
      return (category: LevelCategory.openPlayer, strength: LevelStrength.strong);
    }
  }

  String _getRangeLabel(double value) {
    final pos = value.round();
    
    if (pos <= 2) {
      return 'INTERMEDIATE-${['W', 'M', 'S'][pos]}';
    } else if (pos <= 5) {
      return 'LEVEL G-${['W', 'M', 'S'][pos - 3]}';
    } else if (pos <= 8) {
      return 'LEVEL F-${['W', 'M', 'S'][pos - 6]}';
    } else if (pos <= 11) {
      return 'LEVEL E-${['W', 'M', 'S'][pos - 9]}';
    } else if (pos <= 14) {
      return 'LEVEL D-${['W', 'M', 'S'][pos - 12]}';
    } else {
      return 'OPEN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New Player',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _savePlayer,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
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
              const SizedBox(height: 20),
              // Nickname
              _buildInputField(
                controller: _nicknameController,
                label: 'NICKNAME',
                icon: Icons.person,
                validator: _validateRequired,
              ),
              // Full Name
              _buildInputField(
                controller: _fullNameController,
                label: 'FULL NAME',
                icon: Icons.person_outline,
                validator: _validateRequired,
              ),

              // Mobile Number
              _buildInputField(
                controller: _contactController,
                label: 'MOBILE NUMBER',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
                ],
                validator: _validatePhone,
              ),

              // Email
              _buildInputField(
                controller: _emailController,
                label: 'EMAIL ADDRESS',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),

              // Address
              _buildInputField(
                controller: _addressController,
                label: 'HOME ADDRESS',
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator: _validateRequired,
              ),

              // Remarks
              _buildInputField(
                controller: _remarksController,
                label: 'REMARKS',
                icon: Icons.notes,
                maxLines: 3,
              ),
              // Level Section
              Text(
                'LEVEL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildLevelSelector(),
              const SizedBox(height: 32),

              const SizedBox(height: 20), // Extra space at bottom
            ],
          ),
        ),
      ),
    );
  }
}