import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/core/services/services.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/ui/common/optimized_image.dart';
import 'package:percent_indicator/percent_indicator.dart';

part 'page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    _currentIndexNotifier.value = index;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: const [
                firstPage,
                secondPage,
                thirdPage,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, child) {
                return CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 10.0,
                  percent: (currentIndex + 1) / 3,
                  progressColor: kPrimaryColor,
                  backgroundColor: Colors.grey[300]!,
                  center: IconButton(
                    onPressed: () async {
                      if (currentIndex == 2) {
                        Modular.to.pushReplacementNamed('/auth');
                        await SharedPreference.setBool('isFirst', true);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: Icon(
                      currentIndex == 2
                          ? Icons.check
                          : Icons.arrow_forward_ios_rounded,
                    ),
                    iconSize: 50.0,
                    color: kPrimaryColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
