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
          route: '/home/parental',
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
        const ConnectivityIndicator(size: 20, showText: false),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => Modular.to.pushNamed('/notification'),
          icon: const Icon(Icons.notifications),
        ),
      ],
    ),
    1: defaultAppBar(
      'Appointment',
      actions: [
        const ConnectivityIndicator(size: 20, showText: false),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => Modular.to.pushNamed('/notification'),
          icon: const Icon(Icons.notifications),
        ),
      ],
    ),
    2: defaultAppBar(
      'Parental',
      actions: [
        const ConnectivityIndicator(size: 20, showText: false),
        const SizedBox(width: 8),
      ],
    ),
    3: defaultAppBar(
      'Device',
      actions: [
        IconButton(
          onPressed: () {
            Modular.to.pushNamed(
              '/device-control-list',
            );
          },
          icon: Stack(
            children: [
              const Icon(Icons.pending_actions_outlined),
              Positioned(
                right: 0,
                bottom: -5,
                child: BlocBuilder<DeviceBloc, DeviceState>(
                  builder: (context, state) {
                    if (state is DeviceLoaded) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          context
                              .read<DeviceBloc>()
                              .deviceControlsCount
                              .toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      );
                    } else if (state is DeviceError) {
                      return const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Modular.to.navigate('/auth');
        } else if (state is AuthAuthenticated) {
          // Optionally handle authenticated state
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        drawer: _buildDrawer(),
        appBar: _appBarMap[_selectedIndex],
        body: const RouterOutlet(),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
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
          // ListTile(
          //   leading: const Icon(Icons.notifications),
          //   title: const Text('Notifications'),
          //   onTap: () {
          //     // Modular.to.navigate('/notifications');
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Analytics'),
            onTap: () {
              Modular.to.pushNamed('/analytics');
              // Modular.to.navigate('/medical-records');
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: const Text('History'),
            onTap: () {
              Modular.to.pushNamed('/records');
              // Modular.to.navigate('/medical-records');
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('Parental Code'),
            onTap: parentalQR,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Modular.to.navigate('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          )
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
                  icon: OptimizedIcon(
                    assetPath: _selectedIndex == item.index
                        ? item.selectedIconPath
                        : item.iconPath,
                    size: 24,
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

  void parentalQR() async {
    final userState = context.read<UserBloc>().state;
    User? user;
    if (userState is CurrentUser) {
      user = userState.user;
    } else if (userState is UserLoaded) {
      user = userState.user;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user is currently logged in.'),
        ),
      );
      return;
    }
    final imgUrl = '$parentalQRUrl/${user.userId}';
    print(imgUrl);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      title: 'Parental Code',
      body: CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      btnOkOnPress: () {},
    ).show();
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
