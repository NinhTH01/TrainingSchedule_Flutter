import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreference {
  static Future<bool> getOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final onboarding = prefs.getBool('onboarding') ?? false;
    return onboarding;
  }

  static Future<void> setOnboarding({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding', value);
  }
}
