part of 'main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pages = [
    const Home(),
    // const Calendar(),
    // const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                ),
                spacerWidth(10),
                Text(
                  'Hello, Jude Belingham',
                  style: subtitleTextStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            spacerHeight(20),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: bodyTextStyle,
            ),
            spacerHeight(10),
            Column(
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
            Column(
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
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Device',
                  style: subtitleTextStyle,
                ),
                spacerHeight(8),
                const CardReminder(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
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
