import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/player.dart';
import '../services/player_service.dart';


class EditPlayerScreen extends StatefulWidget {
  final Player player;

  const EditPlayerScreen({super.key, required this.player});

  @override
  State<EditPlayerScreen> createState() {
    return _EditPlayerScreenState();
  }
}

// Helper class to store level position data
class _LevelPosition {
  final LevelCategory category;
  final LevelStrength strength;
  
  _LevelPosition(this.category, this.strength);
}

class _EditPlayerScreenState extends State<EditPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _playerService = PlayerService();
  
  late TextEditingController _nicknameController;
  late TextEditingController _fullNameController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _remarksController;
  
  late BadmintonLevel _selectedLevel;
  
  // Range slider values (0-17 scale covering all levels and strengths)
  RangeValues _levelRange = const RangeValues(4, 10);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nicknameController = TextEditingController(text: widget.player.nickname);
    _fullNameController = TextEditingController(text: widget.player.fullName);
    _contactController = TextEditingController(text: widget.player.contactNumber);
    _emailController = TextEditingController(text: widget.player.email);
    _addressController = TextEditingController(text: widget.player.address);
    _remarksController = TextEditingController(text: widget.player.remarks);
    _selectedLevel = widget.player.level;
    
    // Initialize range slider based on current player's level
    _levelRange = _getLevelRangeFromBadmintonLevel(_selectedLevel);
  }

  RangeValues _getLevelRangeFromBadmintonLevel(BadmintonLevel level) {
    final start = _getPositionFromLevel(level.minCategory, level.minStrength).toDouble();
    final end = _getPositionFromLevel(level.maxCategory, level.maxStrength).toDouble();
    return RangeValues(start, end);
  }

  int _getPositionFromLevel(LevelCategory category, LevelStrength strength) {
    int basePosition = 0;
    switch (category) {
      case LevelCategory.intermediate:
        basePosition = 0;
        break;
      case LevelCategory.levelG:
        basePosition = 3;
        break;
      case LevelCategory.levelF:
        basePosition = 6;
        break;
      case LevelCategory.levelE:
        basePosition = 9;
        break;
      case LevelCategory.levelD:
        basePosition = 12;
        break;
      case LevelCategory.openPlayer:
        return 15; // Open Player is always position 15, regardless of strength
      case LevelCategory.beginner:
        return 0; // Fallback for beginner
    }
    return basePosition + strength.index;
  }

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

  void _updatePlayer() {
    if (_formKey.currentState!.validate()) {
      final updatedPlayer = widget.player.copyWith(
        nickname: _nicknameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        contactNumber: _contactController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        remarks: _remarksController.text.trim(),
        level: _selectedLevel,
      );

      _playerService.updatePlayer(widget.player.id, updatedPlayer);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Player updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, true);
    }
  }



  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete "${widget.player.nickname}" (${widget.player.fullName})?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      _playerService.deletePlayer(widget.player.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.player.nickname} has been deleted'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, true);
      }
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

  _LevelPosition _getLevelFromPosition(int position) {
    if (position <= 2) {
      return _LevelPosition(LevelCategory.intermediate, LevelStrength.values[position]);
    } else if (position <= 5) {
      return _LevelPosition(LevelCategory.levelG, LevelStrength.values[position - 3]);
    } else if (position <= 8) {
      return _LevelPosition(LevelCategory.levelF, LevelStrength.values[position - 6]);
    } else if (position <= 11) {
      return _LevelPosition(LevelCategory.levelE, LevelStrength.values[position - 9]);
    } else if (position <= 14) {
      return _LevelPosition(LevelCategory.levelD, LevelStrength.values[position - 12]);
    } else {
      // Open Player - strength doesn't matter, always use strong as default
      return _LevelPosition(LevelCategory.openPlayer, LevelStrength.strong);
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
          'Edit Player',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _updatePlayer,
            child: const Text(
              'Update',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _confirmDelete,
            tooltip: 'Delete Player',
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
              // Player info header
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 30,
                        child: Text(
                          widget.player.nickname.isNotEmpty 
                              ? widget.player.nickname[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Editing Player Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            Text(
                              'ID: ${widget.player.id}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

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

              // Contact Number
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
              const SizedBox(height: 20), // Extra space at bottom
            ],
          ),
        ),
      ),
    );
  }
}