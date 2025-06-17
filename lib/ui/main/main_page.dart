part of 'main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late final List<BottomNavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _navItems = _initializeNavItems();
    Modular.to.navigate('/home/reminder');
  }

  List<BottomNavItem> _initializeNavItems() => [
        BottomNavItem(
          index: 0,
          route: '/home/reminder',
          label: 'Home',
          iconPath: 'assets/icons/home.png',
          selectedIconPath: 'assets/icons/home-selected.png',
        ),
        BottomNavItem(
          index: 1,
          route: '/home/appointment',
          label: 'Appointment',
          iconPath: 'assets/icons/calendar.png',
          selectedIconPath: 'assets/icons/calendar-selected.png',
        ),
        BottomNavItem(
          index: 2,
          route: '/home/parental/list',
          label: 'Parental',
          iconPath: 'assets/icons/family.png',
          selectedIconPath: 'assets/icons/family-selected.png',
        ),
        BottomNavItem(
          index: 3,
          route: '/home/device',
          label: 'Device',
          iconPath: 'assets/icons/pill-dosage.png',
          selectedIconPath: 'assets/icons/pill-dosage-selected.png',
        ),
      ];

  final Map<int, Widget> _bodyMap = {
    0: const Home(),
    1: const Appointment(),
    2: const ListParental(),
    3: const DeviceView(),
  };

  final Map<int, AppBar> _appBarMap = {
    0: defaultAppBar(
      'Reminders',
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ],
    ),
    1: defaultAppBar(
      'Appointment',
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ],
    ),
    2: defaultAppBar('Parental'),
    3: defaultAppBar(
      'Device',
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.playlist_remove),
        ),
      ],
    ),
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Modular.to.navigate(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _appBarMap[_selectedIndex],
      body: _bodyMap[_selectedIndex] ?? const Home(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: kPrimaryColor),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ..._navItems.map((item) => ListTile(
                leading: _getDrawerIcon(item.index),
                title: Text(item.label),
                onTap: () {
                  _onItemTapped(item.index);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
        children: _navItems
            .map((item) => CustomIconButton(
                  onPressed: () => _onItemTapped(item.index),
                  icon: Image.asset(
                    _selectedIndex == item.index
                        ? item.selectedIconPath
                        : item.iconPath,
                    width: 24,
                    color: _selectedIndex == item.index
                        ? kPrimaryColor
                        : Colors.black,
                  ),
                  label: item.label,
                  isSelected: _selectedIndex == item.index,
                ))
            .toList(),
      ),
    );
  }

  Icon _getDrawerIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.home);
      case 1:
        return const Icon(Icons.calendar_today);
      case 2:
        return const Icon(Icons.group);
      case 3:
        return const Icon(Icons.medical_services);
      default:
        return const Icon(Icons.home);
    }
  }
}

class BottomNavItem {
  final int index;
  final String route;
  final String label;
  final String iconPath;
  final String selectedIconPath;

  BottomNavItem({
    required this.index,
    required this.route,
    required this.label,
    required this.iconPath,
    required this.selectedIconPath,
  });
}

class CustomIconButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? kPrimaryColor : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
