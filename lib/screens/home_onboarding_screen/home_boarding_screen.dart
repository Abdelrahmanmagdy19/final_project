import 'package:cure_link/screens/lets_get_started_screen/lets_get_started_screen.dart';
import 'package:cure_link/utils/app_animation.dart';
import 'package:cure_link/utils/app_text.dart';
import 'package:cure_link/widgets/custom_on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeOnBoardingScreen extends StatefulWidget {
  const HomeOnBoardingScreen({super.key});

  @override
  State<HomeOnBoardingScreen> createState() => _HomeOnBoardingScreenState();
}

class _HomeOnBoardingScreenState extends State<HomeOnBoardingScreen> {
  final PageController _pageController = PageController();
  static const int _totalPages = 2;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_updateCurrentPage);
  }

  void _updateCurrentPage() {
    setState(() {
      _currentPage = _pageController.page!.round();
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_updateCurrentPage);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildPageView(),
          _buildSkipButton(),
          _buildPageIndicator(),
          _buildNavigationButton(),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      children: const [
        CustomOnBoarding(
          lottieImage: AppAnimation.doctorAnimation,
          title: AppText.onBoardingFindDoctor,
        ),
        CustomOnBoarding(
          lottieImage: AppAnimation.aiAnimation,
          title: AppText.onBoardingAiChat,
        ),
      ],
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: 40.0,
      right: 20.0,
      child: TextButton(
        onPressed: () => _pageController.jumpToPage(_totalPages - 1),
        child: const Text(
          'Skip',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Align(
      alignment: const Alignment(0, 0.7),
      child: SmoothPageIndicator(
        controller: _pageController,
        count: _totalPages,
        effect: const WormEffect(
          dotHeight: 12,
          dotWidth: 12,
          activeDotColor: Color(0xFF14AE9D),
          dotColor: Color.fromARGB(255, 173, 226, 219),
        ),
      ),
    );
  }

  Widget _buildNavigationButton() {
    return Positioned(
      bottom: 70.0,
      right: 20.0,
      child: FloatingActionButton(
        onPressed: () {
          if (_currentPage == _totalPages - 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LetsGetStarted()),
            );
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
        backgroundColor: const Color(0xFF14AE9D),
        child: Icon(
          _currentPage == _totalPages - 1
              ? Icons.done
              : Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
    );
  }
}
