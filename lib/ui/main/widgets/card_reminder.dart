part of 'widgets.dart';

class CardReminder extends StatelessWidget {
  const CardReminder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
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
          Expanded(
            flex: 4, // 40% of the Row
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Paracetamol',
                  style: subtitleTextStyle,
                ),
                Text(
                  '1 Tablet before meal',
                  style: captionTextStyle,
                ),
                Text(
                  'Left: 2',
                  style: bodyTextStyle,
                )
              ],
            ),
          ),
          Expanded(
            flex: 4, // 40% of the Row
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  child: VerticalDivider(
                    width: 20,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: darkGrayColor,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '10:00',
                          style: subtitleTextStyle.copyWith(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: ' AM',
                              style: subtitleTextStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Mon, Tue, Wed, Thu, Fri, asjdfkaj',
                        style: captionTextStyle.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2, // 20% of the Row
            child: Switch(
              value: true,
              onChanged: (bool value) {
                // Handle on/off toggle
              },
            ),
          ),
        ],
      ),
    );
  }
}
