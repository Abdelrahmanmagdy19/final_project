import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomOnBoarding extends StatelessWidget {
  const CustomOnBoarding({
    super.key,
    required this.lottieImage,
    required this.title,
    this.subtitle = '',
  });

  final String lottieImage;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 2, child: LottieBuilder.asset(lottieImage)),
        _buildContentSection(),
      ],
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildSubtitle(),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    if (subtitle.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        subtitle,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
