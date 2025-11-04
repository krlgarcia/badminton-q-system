import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _settingsService = SettingsService();
  
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final _shuttleCockPriceController = TextEditingController();
  
  bool _divideCourtEqually = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final settings = _settingsService.getSettings();
    _courtNameController.text = settings.courtName;
    _courtRateController.text = settings.courtRate.toString();
    _shuttleCockPriceController.text = settings.shuttleCockPrice.toString();
    setState(() {
      _divideCourtEqually = settings.divideCourtEqually;
    });
  }

  @override
  void dispose() {
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttleCockPriceController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
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

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      // Parse values and save to service
      final courtName = _courtNameController.text.trim();
      final courtRate = double.parse(_courtRateController.text.trim());
      final shuttleCockPrice = double.parse(_shuttleCockPriceController.text.trim());
      
      _settingsService.updateCourtName(courtName);
      _settingsService.updateCourtRate(courtRate);
      _settingsService.updateShuttleCockPrice(shuttleCockPrice);
      _settingsService.updateDivideCourtEqually(_divideCourtEqually);

    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? helperText,
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
            helperText: helperText,
            helperMaxLines: 2,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: _saveSettings,
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
              // Court Name
              _buildInputField(
                controller: _courtNameController,
                label: 'Default Court Name',
                icon: Icons.sports_tennis,
                validator: _validateRequired,
              ),
              
              // Court Rate
              _buildInputField(
                controller: _courtRateController,
                label: 'Default Court Rate (Per Hour)',
                icon: Icons.attach_money,
                validator: _validatePrice,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              
              // Shuttle Cock Price
              _buildInputField(
                controller: _shuttleCockPriceController,
                label: 'Default Shuttle Cock Price',
                icon: Icons.sports,
                validator: _validatePrice,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              
              // Divide Court Equally Checkbox
              Card(
                elevation: 0,
                color: Colors.grey[100],
                child: CheckboxListTile(
                  title: const Text(
                    'Divide the court equally among players',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: _divideCourtEqually,
                  onChanged: (bool? value) {
                    setState(() {
                      _divideCourtEqually = value ?? true;
                    });
                  },
                  activeColor: Colors.blue,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Info Card
              if (!_divideCourtEqually)
                Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'When unchecked, you will need to calculate the court rate per game instead of per hour.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Summary Card
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Court:', _courtNameController.text),
                      _buildSummaryRow('Rate/Hour:', '₱${_courtRateController.text}'),
                      _buildSummaryRow('Shuttle Cock:', '₱${_shuttleCockPriceController.text}'),
                      _buildSummaryRow('Division:', _divideCourtEqually ? 'Equal among players' : 'Per game'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
