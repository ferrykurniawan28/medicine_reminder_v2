part of 'widgets.dart';

class NextMedication extends StatelessWidget {
  const NextMedication({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Next Medication',
            style: subtitleTextStyle,
          ),
          spacerHeight(8),
          const CardReminder(),
          const CardReminder(),
        ],
      ),
    );
  }
}
