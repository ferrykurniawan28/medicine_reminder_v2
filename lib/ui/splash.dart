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

    // Check if user has completed onboarding
    final isFirst = await SharedPreference.getBool('isFirst');

    if (!isFirst) {
      // User hasn't completed onboarding, show onboarding
      await Modular.to.pushReplacementNamed('/boarding');
      return;
    }

    // User has completed onboarding, check user credentials
    final userId = await SharedPreference.getInt('userId');

    if (userId > 0) {
      // User has saved credentials, wait a bit for UserBloc to load and then go to home
      await Future.delayed(const Duration(milliseconds: 500));

      await Modular.to.pushReplacementNamed('/home');
    } else {
      // No saved user credentials, go to authentication
      await Modular.to.pushReplacementNamed('/auth');
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
