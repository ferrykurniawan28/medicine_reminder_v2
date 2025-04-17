part of '../main.dart';

class ParentalMainPage extends StatefulWidget {
  const ParentalMainPage({super.key});

  @override
  State<ParentalMainPage> createState() => _ParentalMainPageState();
}

class _ParentalMainPageState extends State<ParentalMainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const ListParental(),
    const ParentalDetail(),
  ];

  @override
  Widget build(BuildContext context) {
    return _pages[_currentIndex];
  }
}
