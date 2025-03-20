import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/services/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

part 'page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            child: CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 10.0,
              percent: (_currentIndex + 1) / 3,
              progressColor: Colors.blue,
              backgroundColor: Colors.grey[300]!,
              center: IconButton(
                onPressed: () async {
                  if (_currentIndex == 2) {
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
                  _currentIndex == 2
                      ? Icons.check
                      : Icons.arrow_forward_ios_rounded,
                ),
                iconSize: 50.0,
                color: primaryColor,
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: CircularProgressIndicator(
          //     value: (_currentIndex + 1) / 3,
          //     backgroundColor: Colors.grey[300],
          //     valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Expanded(
          //         child: ElevatedButton(
          //           onPressed: () {
          //             if (_currentIndex == 2) {
          //               Modular.to.pushReplacementNamed('/auth');
          //             } else {
          //               _pageController.nextPage(
          //                 duration: const Duration(milliseconds: 300),
          //                 curve: Curves.easeInOut,
          //               );
          //             }
          //           },
          //           child: const Text('Next'),
          //         ),
          //       ),
          //       spacerWidth(10),
          //       if (_currentIndex != 2)
          //         Expanded(
          //           child: ElevatedButton(
          //             onPressed: () {
          //               Modular.to.pushReplacementNamed('/auth');
          //             },
          //             child: const Text('Skip'),
          //           ),
          //         ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
