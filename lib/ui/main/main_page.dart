part of 'main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Home(),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomIconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  icon: Image.asset(
                    _selectedIndex == 0
                        ? 'assets/icons/home-selected.png'
                        : 'assets/icons/home.png',
                    width: 24,
                    color: _selectedIndex == 0 ? darkGrayColor : Colors.black,
                  ),
                  label: 'Home',
                  isSelected: _selectedIndex == 0,
                ),
                CustomIconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  icon: Image.asset(
                    _selectedIndex == 1
                        ? 'assets/icons/calendar-selected.png'
                        : 'assets/icons/calendar.png',
                    width: 24,
                    color: _selectedIndex == 1 ? darkGrayColor : Colors.black,
                  ),
                  label: 'Calendar',
                  isSelected: _selectedIndex == 1,
                ),
                CustomIconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  icon: Image.asset(
                    _selectedIndex == 2
                        ? 'assets/icons/group-selected.png'
                        : 'assets/icons/group.png',
                    width: 24,
                    color: _selectedIndex == 2 ? darkGrayColor : Colors.black,
                  ),
                  label: 'Group',
                  isSelected: _selectedIndex == 2,
                ),
                CustomIconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                  icon: Image.asset(
                    _selectedIndex == 3
                        ? 'assets/icons/notification-selected.png'
                        : 'assets/icons/notification.png',
                    width: 24,
                    color: _selectedIndex == 3 ? darkGrayColor : Colors.black,
                  ),
                  label: 'Notification',
                  isSelected: _selectedIndex == 3,
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.darken(0.1),
                    softBlueColor.lighten(1),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final bool isSelected;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon,
          Text(
            widget.label,
            style: TextStyle(
              color: widget.isSelected ? darkGrayColor : Colors.black,
              fontWeight:
                  widget.isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
