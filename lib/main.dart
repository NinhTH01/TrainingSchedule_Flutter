import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/data/local/shared_preference/onboarding_preference.dart';
import 'package:training_schedule/presentation/navigation/navigation_view.dart';
import 'package:training_schedule/presentation/onboarding/onboarding_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onboarding = await OnboardingPreference.getOnboarding();
  runApp(ProviderScope(child: MyApp(onboarding: onboarding)));
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
