import 'package:training_schedule/models/onboarding/onboarding_slide_info.dart';

class OnboardingViewModel {
  List<OnboardingSlideInfo> items = [
    OnboardingSlideInfo(
        description:
            "Monitor your performance with detailed running stats. Track your distance, pace, and progress over time to achieve your fitness goals.",
        image: "assets/onboarding/onboarding1.png",
        title: "Track Your Run"),
    OnboardingSlideInfo(
        description:
            "Stay prepared with accurate weather forecasts. Get real-time updates on temperature, humidity, and precipitation to plan your runs around the best conditions.",
        image: "assets/onboarding/onboarding2.png",
        title: "Weather Forecast"),
    OnboardingSlideInfo(
        description:
            "Plan your perfect run with our interactive map feature. Explore new routes, track your favorite paths, and never get lost with real-time navigation descriptions",
        image: "assets/onboarding/onboarding3.png",
        title: "Map Your Route")
  ];
}
