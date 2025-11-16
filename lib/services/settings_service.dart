import '../models/user_settings.dart';

class SettingsService {
  // Static settings instance (singleton-like behavior without complex patterns)
  static UserSettings _settings = UserSettings(
    courtName: 'Main Court',
    courtRate: 400.00,
    shuttleCockPrice: 75.00,
    divideCourtRate: true,
    divideShuttleCockPrice: true,
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

  void updateDivideCourtRate(bool divide) {
    _settings.divideCourtRate = divide;
  }

  void updateDivideShuttleCockPrice(bool divide) {
    _settings.divideShuttleCockPrice = divide;
  }

  // Reset to defaults
  void resetToDefaults() {
    _settings = UserSettings(
      courtName: 'Main Court',
      courtRate: 400.00,
      shuttleCockPrice: 75.00,
      divideCourtRate: true,
      divideShuttleCockPrice: true,
    );
  }
}
