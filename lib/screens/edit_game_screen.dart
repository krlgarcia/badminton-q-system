import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game.dart';
import '../services/game_service.dart';

class EditGameScreen extends StatefulWidget {
  final Game game;

  const EditGameScreen({super.key, required this.game});

  @override
  State<EditGameScreen> createState() {
    return _EditGameScreenState();
  }
}

class _EditGameScreenState extends State<EditGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _gameService = GameService();

  final _gameTitleController = TextEditingController();
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final _shuttleCockPriceController = TextEditingController();

  bool _divideCourtRate = true;
  bool _divideShuttleCockPrice = true;
  late List<CourtSchedule> _schedules;

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  void _loadGameData() {
    _gameTitleController.text = widget.game.title;
    _courtNameController.text = widget.game.courtName;
    _courtRateController.text = widget.game.courtRate.toString();
    _shuttleCockPriceController.text = widget.game.shuttleCockPrice.toString();
    _divideCourtRate = widget.game.divideCourtRate;
    _divideShuttleCockPrice = widget.game.divideShuttleCockPrice;
    _schedules = List.from(widget.game.schedules);
  }

  @override
  void dispose() {
    _gameTitleController.dispose();
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttleCockPriceController.dispose();
    super.dispose();
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final number = double.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number <= 0) {
      return 'Price must be greater than 0';
    }

    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _addSchedule() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (selectedDate == null || !mounted) return;

    final courtNumber = await _showCourtNumberDialog();
    if (courtNumber == null || !mounted) return;

    final startTime = await _showTimePicker(selectedDate, 'Start Time');
    if (startTime == null || !mounted) return;

    final endTime = await _showTimePicker(selectedDate, 'End Time');
    if (endTime == null || !mounted) return;

    if (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
        ),
      );
      return;
    }

    setState(() {
      _schedules.add(CourtSchedule(
        courtNumber: courtNumber,
        startTime: startTime,
        endTime: endTime,
      ));
    });
  }

  Future<String?> _showCourtNumberDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Court Number'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Court #',
              hintText: 'e.g., Court 1, Court A',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> _showTimePicker(DateTime date, String title) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: title,
    );

    if (time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  void _removeSchedule(int index) {
    setState(() {
      _schedules.removeAt(index);
    });
  }

  void _updateGame() {
    if (_formKey.currentState!.validate()) {
      if (_schedules.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one schedule'),
          ),
        );
        return;
      }

      widget.game.title = _gameTitleController.text.trim();
      widget.game.courtName = _courtNameController.text.trim();
      widget.game.courtRate = double.parse(_courtRateController.text.trim());
      widget.game.shuttleCockPrice = double.parse(_shuttleCockPriceController.text.trim());
      widget.game.divideCourtRate = _divideCourtRate;
      widget.game.divideShuttleCockPrice = _divideShuttleCockPrice;
      widget.game.schedules = _schedules;

      _gameService.updateGame(widget.game.id, widget.game);
      Navigator.pop(context, true);
    }
  }

  void _cancel() {
    Navigator.pop(context);
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
          label.toUpperCase(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Game',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _cancel,
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: _updateGame,
            child: const Text(
              'Update Game',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              // Game Title
              _buildInputField(
                controller: _gameTitleController,
                label: 'Game Title (Optional)',
                icon: Icons.title,
              ),

              // Court Name
              _buildInputField(
                controller: _courtNameController,
                label: 'Court Name',
                icon: Icons.sports_tennis,
                validator: _validateRequired,
              ),

              // Schedules Section
              Text(
                'SCHEDULES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Schedule List
              if (_schedules.isEmpty)
                Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'No schedules added yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = _schedules[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          schedule.courtNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${_formatDate(schedule.startTime)}\n${schedule.getTimeRange()} (${schedule.getDurationInHours().toStringAsFixed(1)} hrs)',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _removeSchedule(index);
                          },
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 8),

              // Add Schedule Button
              OutlinedButton.icon(
                onPressed: _addSchedule,
                icon: const Icon(Icons.add),
                label: const Text('Add Schedule'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 20),

              // Court Rate
              _buildInputField(
                controller: _courtRateController,
                label: 'Court Rate (Per Hour)',
                icon: Icons.payments,
                validator: _validatePrice,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),

              // Shuttle Cock Price
              _buildInputField(
                controller: _shuttleCockPriceController,
                label: 'Shuttle Cock Price',
                icon: Icons.sports,
                validator: _validatePrice,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),

              // Divide Court Rate Checkbox
              Card(
                elevation: 0,
                color: Colors.grey[100],
                child: CheckboxListTile(
                  title: const Text(
                    'Divide court rate among players',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: _divideCourtRate,
                  onChanged: (bool? value) {
                    setState(() {
                      _divideCourtRate = value ?? true;
                    });
                  },
                  activeColor: Colors.blue,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),

              const SizedBox(height: 12),

              // Divide Shuttle Cock Price Checkbox
              Card(
                elevation: 0,
                color: Colors.grey[100],
                child: CheckboxListTile(
                  title: const Text(
                    'Divide shuttle cock price among players',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: _divideShuttleCockPrice,
                  onChanged: (bool? value) {
                    setState(() {
                      _divideShuttleCockPrice = value ?? true;
                    });
                  },
                  activeColor: Colors.blue,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
