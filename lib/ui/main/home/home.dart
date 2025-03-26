part of '../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Medication'),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // const Appbar(),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     DateFormat.yMMMMd().format(DateTime.now()),
          //     style: bodyTextStyle,
          //   ),
          // ),
          const NextMedication(),
        ],
      ),
    );
  }
}
