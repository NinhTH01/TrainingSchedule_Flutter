import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_schedule/presentation/navigation/navigation_view.dart';
import 'package:training_schedule/presentation/onboarding/onboarding_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;

  const MyApp({super.key, required this.onboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: onboarding ? const NavigationView() : const OnboardingView(),
    );
  }
}
