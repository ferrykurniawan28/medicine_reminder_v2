part of 'widgets.dart';

class Appointment extends StatelessWidget {
  const Appointment({
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
            'Your Next Appointment',
            style: subtitleTextStyle,
          ),
          spacerHeight(8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              // gradient: LinearGradient(
              //   colors: [
              //     softBlueColor,
              //     softBlueColor.lighten(0.1),
              //   ],
              // ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                defaultShadow,
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/medical.png',
                  width: 60,
                  height: 60,
                ),
                spacerWidth(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. Jane Doe',
                        style: subtitleTextStyle,
                      ),
                      Text(
                        'Dermatologist asodjf aosdpijf opasijdf saopdjf opasij sa;ldkjf;l',
                        style: captionTextStyle.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: VerticalDivider(
                    width: 20,
                    thickness: 2,
                    indent: 0,
                    endIndent: 0,
                    color: darkGrayColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '10 Jul',
                      style: subtitleTextStyle,
                    ),
                    Text(
                      '10:00 AM',
                      style: captionTextStyle,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
