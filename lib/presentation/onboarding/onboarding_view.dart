import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import "package:training_schedule/presentation/navigation/navigation_view.dart";
import "package:training_schedule/presentation/onboarding/onboarding_view_model.dart";

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = OnboardingViewModel();
  final _pageController = PageController();

  void _handleNavigateToHomeView() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const NavigationView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: PageView.builder(
        controller: _pageController,
        itemCount: _controller.items.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(_controller.items[index].image),
              const SizedBox(height: 15),
              Text(
                _controller.items[index].title,
                style:
                    const TextStyle(fontSize: 31, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Text(_controller.items[index].description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 150),
              SmoothPageIndicator(
                controller: _pageController,
                count: _controller.items.length,
                effect: const WormEffect(
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                  spacing: 8.0,
                  radius: 8.0,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: () async {
                    if (index < _controller.items.length - 1) {
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    } else {
                      _handleNavigateToHomeView();
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool("onboarding", true);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text(index == _controller.items.length - 1
                      ? 'Get started!'
                      : "Next"),
                ),
              )
            ],
          );
        },
      ),
    ));
  }
}
