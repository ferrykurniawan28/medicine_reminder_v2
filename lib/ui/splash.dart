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
      if (!mounted) return;
      final userBloc = BlocProvider.of<UserBloc>(context);
      final userState = userBloc.state;
      if (userState is CurrentUser) {
        Modular.to.pushReplacementNamed('/home');
      } else {
        Modular.to.pushReplacementNamed('/boarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Text('Minder',
            style: titleTextStyle.copyWith(color: Colors.white, fontSize: 30)),
      ),
    );
  }
}
