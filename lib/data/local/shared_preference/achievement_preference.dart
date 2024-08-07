import 'package:shared_preferences/shared_preferences.dart';

class AchievementPreference {
  static Future<bool> getAchievement() async {
    final prefs = await SharedPreferences.getInstance();
    final achievement = prefs.getBool('achievement') ?? false;
    return achievement;
  }

  static Future<void> setAchievement({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('achievement', value);
  }
}
