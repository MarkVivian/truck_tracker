class Preferences {
  // Assets paths
  static const String backgroundImage = 'assets/images/background_auth.jpg';

  // Colors (in ARGB format)
  static const int primaryGreen = 0xFF00A651;
  static const int secondaryGreen = 0xFF00FF41;
  static const int backgroundGreen = 0xFF008C45;
  static const int overlayColor = 0x33008C45; // Green with 20% opacity (33 in hex is about 20% in decimal)

  // Authentication credentials
  static const Map<String, Map<String, String>> userCredentials = {
    'receptionist': {
      'id': '12345',
      'password': 'password'
    },
    'admin': {
      'id': '00000',
      'password': 'admin'
    }
  };

  // Text styles
  static const double headerFontSize = 32.0;
  static const double buttonFontSize = 18.0;
  static const double inputFontSize = 16.0;

  // Dimensions
  static const double loginCardWidth = 400.0;
  static const double loginCardPadding = 32.0;
  static const double inputSpacing = 16.0;
  static const double buttonHeight = 50.0;
  static const double borderRadius = 16.0;
}