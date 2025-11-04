import '../models/user_settings.dart';

class SettingsService {
  // Static settings instance (singleton-like behavior without complex patterns)
  static UserSettings _settings = UserSettings(
    courtName: 'Main Court',
    courtRate: 400.0,
    shuttleCockPrice: 75.0,
    divideCourtEqually: true,
  );

  // Get current settings
  UserSettings getSettings() {
    return _settings;
  }

  // Update settings
  void updateSettings(UserSettings newSettings) {
    _settings = newSettings;
  }

  // Update individual fields
  void updateCourtName(String courtName) {
    _settings.courtName = courtName;
  }

  void updateCourtRate(double courtRate) {
    _settings.courtRate = courtRate;
  }

  void updateShuttleCockPrice(double price) {
    _settings.shuttleCockPrice = price;
  }

  void updateDivideCourtEqually(bool divide) {
    _settings.divideCourtEqually = divide;
  }

  // Reset to defaults
  void resetToDefaults() {
    _settings = UserSettings(
      courtName: 'Main Court',
      courtRate: 400.0,
      shuttleCockPrice: 75.0,
      divideCourtEqually: true,
    );
  }
}
