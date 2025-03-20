part of 'onboarding.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 300),
            spacerHeight(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleTextStyle),
                spacerHeight(10),
                Text(description, style: bodyTextStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const firstPage = OnboardingPage(
  image: 'assets/images/remind.png',
  title: 'Stay on Track with Your Medication',
  description:
      'Never miss a dose again! Our app keeps you consistent with your medication schedule.',
);

const secondPage = OnboardingPage(
  image: 'assets/images/note-list.png',
  title: 'Minder, Just for You',
  description:
      'Get personalized reminders for every medicine you take—on time, every time.',
);

const thirdPage = OnboardingPage(
  image: 'assets/images/schedule.png',
  title: 'Your Health, Your Control',
  description:
      'Track your medication history and stay organized effortlessly. Take control now!',
);
