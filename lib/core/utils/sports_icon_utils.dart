class SportsIconUtils {
  static const Map<String, String> _sportsIconMap = {
    'basketball': 'assets/icons/basketball.png',
    'football': 'assets/icons/football.png',
    'cricket': 'assets/icons/cricket_ball.png',
    'tennis': 'assets/icons/tennis.png',
    'soccer': 'assets/icons/soccer.png',
    'volleyball': 'assets/icons/volleyball.png',
    'badminton': 'assets/icons/badminton.png',
    'table tennis': 'assets/icons/table_tennis.png',
    'squash': 'assets/icons/squash.png',
    'hockey': 'assets/icons/hockey.png',
    'baseball': 'assets/icons/baseball.png',
    'golf': 'assets/icons/golf.png',
    'swimming': 'assets/icons/swimming.png',
    'boxing': 'assets/icons/boxing.png',
    'martial arts': 'assets/icons/martial_arts.png',
    'gym': 'assets/icons/gym.png',
    'fitness': 'assets/icons/fitness.png',
    'yoga': 'assets/icons/yoga.png',
    'pilates': 'assets/icons/pilates.png',
    'cycling': 'assets/icons/cycling.png',
  };

  /// Returns the asset path for a given sport name
  /// If no specific icon exists, returns basketball as default
  static String getSportIconPath(String sportName) {
    final normalizedName = sportName.toLowerCase().trim();
    return _sportsIconMap[normalizedName] ?? 'assets/icons/basketball.png';
  }

  /// Returns all available sport names that have icons
  static List<String> getAvailableSports() {
    return _sportsIconMap.keys.toList();
  }

  /// Checks if an icon exists for the given sport name
  static bool hasIconForSport(String sportName) {
    final normalizedName = sportName.toLowerCase().trim();
    return _sportsIconMap.containsKey(normalizedName);
  }
}
