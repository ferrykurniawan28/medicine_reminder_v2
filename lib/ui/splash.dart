part of 'ui.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _navigationTriggered = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600), // Reduced duration
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut, // More efficient curve
    ));

    // Start fade animation immediately
    _fadeController.forward();

    // Use microtask to avoid blocking the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay();
    });
  }

  Future<void> _navigateAfterDelay() async {
    if (_navigationTriggered) return;
    _navigationTriggered = true;

    // Reduced splash duration
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    // Stop animation before navigation to free resources
    _fadeController.stop();

    // Check user state asynchronously
    final userBloc = BlocProvider.of<UserBloc>(context);
    final userState = userBloc.state;

    // Navigate based on user state
    if (userState is CurrentUser) {
      await Modular.to.pushReplacementNamed('/home');
    } else if (userState is UserLoaded) {
      await Modular.to.pushReplacementNamed('/home');
    } else {
      await Modular.to.pushReplacementNamed('/boarding');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Minder',
            style: titleTextStyle.copyWith(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
