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
    _settings = _settings.copyWith(courtName: courtName);
  }

  void updateCourtRate(double courtRate) {
    _settings = _settings.copyWith(courtRate: courtRate);
  }

  void updateShuttleCockPrice(double price) {
    _settings = _settings.copyWith(shuttleCockPrice: price);
  }

  void updateDivideCourtEqually(bool divide) {
    _settings = _settings.copyWith(divideCourtEqually: divide);
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
