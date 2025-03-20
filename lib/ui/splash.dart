part of 'ui.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      Modular.to.pushReplacementNamed('/boarding');
      // TODO: Uncomment the code below
      // final bool isFirst = await SharedPreference.getBool('isFirst');
      // isFirst
      //     ? Modular.to.pushReplacementNamed('/auth')
      //     : Modular.to.pushReplacementNamed('/boarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text('Minder', style: titleTextStyle),
        ),
      ),
    );
  }
}
