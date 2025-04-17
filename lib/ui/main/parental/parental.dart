part of '../main.dart';

class ParentalMainPage extends StatefulWidget {
  const ParentalMainPage({super.key});

  @override
  State<ParentalMainPage> createState() => _ParentalMainPageState();
}

class _ParentalMainPageState extends State<ParentalMainPage> {
  @override
  void initState() {
    super.initState();
    Modular.to.navigate('/home/parental/list');
  }

  @override
  Widget build(BuildContext context) {
    return const RouterOutlet();
  }
}
