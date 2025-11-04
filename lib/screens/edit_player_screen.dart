import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';
import '../widgets/badminton_level_slider.dart';

class EditPlayerScreen extends StatefulWidget {
  final Player player;

  const EditPlayerScreen({super.key, required this.player});

  @override
  State<EditPlayerScreen> createState() {
    return _EditPlayerScreenState();
  }
}

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
  
  late LevelCategory _selectedMinCategory;
  late LevelStrength _selectedMinStrength;
  late LevelCategory _selectedMaxCategory;
  late LevelStrength _selectedMaxStrength;
  late RangeValues _selectedLevelRange;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.player.nickname);
    _fullNameController = TextEditingController(text: widget.player.fullName);
    _contactController = TextEditingController(text: widget.player.contactNumber);
    _emailController = TextEditingController(text: widget.player.email);
    _addressController = TextEditingController(text: widget.player.address);
    _remarksController = TextEditingController(text: widget.player.remarks);
    _selectedMinCategory = widget.player.level.minCategory;
    _selectedMinStrength = widget.player.level.minStrength;
    _selectedMaxCategory = widget.player.level.maxCategory;
    _selectedMaxStrength = widget.player.level.maxStrength;
    _selectedLevelRange = RangeValues(
      _getPositionFromLevel(_selectedMinCategory, _selectedMinStrength),
      _getPositionFromLevel(_selectedMaxCategory, _selectedMaxStrength),
    );
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

  double _getPositionFromLevel(LevelCategory category, LevelStrength strength) {
    int categoryBase = 0;
    
    if (category == LevelCategory.beginner) {
      categoryBase = 0;
    } else if (category == LevelCategory.intermediate) {
      categoryBase = 3;
    } else if (category == LevelCategory.levelG) {
      categoryBase = 6;
    } else if (category == LevelCategory.levelF) {
      categoryBase = 9;
    } else if (category == LevelCategory.levelE) {
      categoryBase = 12;
    } else if (category == LevelCategory.levelD) {
      categoryBase = 15;
    } else if (category == LevelCategory.openPlayer) {
      return 18;
    }
    
    int strengthOffset = 0;
    if (strength == LevelStrength.weak) {
      strengthOffset = 0;
    } else if (strength == LevelStrength.mid) {
      strengthOffset = 1;
    } else if (strength == LevelStrength.strong) {
      strengthOffset = 2;
    }
    
    return (categoryBase + strengthOffset).toDouble();
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

  void _updatePlayer() {
    if (_formKey.currentState!.validate()) {
      widget.player.nickname = _nicknameController.text;
      widget.player.fullName = _fullNameController.text;
      widget.player.contactNumber = _contactController.text;
      widget.player.email = _emailController.text;
      widget.player.address = _addressController.text;
      widget.player.remarks = _remarksController.text;
      widget.player.level = BadmintonLevel(
        minCategory: _selectedMinCategory,
        minStrength: _selectedMinStrength,
        maxCategory: _selectedMaxCategory,
        maxStrength: _selectedMaxStrength,
      );

      _playerService.updatePlayer(widget.player.id, widget.player);
      
      Navigator.pop(context, true);
    }
  }

  void _deletePlayer() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "${widget.player.nickname}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
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
          SnackBar(content: Text('${widget.player.nickname} has been deleted')),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Player'),
        actions: [
          TextButton(
            onPressed: _updatePlayer,
            child: const Text('Update'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deletePlayer,
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
