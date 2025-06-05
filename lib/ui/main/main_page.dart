part of 'main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    Modular.to.navigate('/home/reminder');
  }

  Map<int, AppBar> get appBars => {
        0: defaultAppBar(
          'Reminders',
        ),
        1: defaultAppBar(
          'Appointment',
        ),
        2: defaultAppBar(
          'Parental',
        ),
        3: defaultAppBar(
          'Device',
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.playlist_remove))
          ],
        ),
      };

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = const Home(); // ReminderHomePage -> Home
        break;
      case 1:
        body = const Appointment(); // AppointmentHomePage -> Appointment
        break;
      case 2:
        body = const ListParental(); // ParentalHomePage -> ListParental
        break;
      case 3:
        body = const DeviceView(); // DeviceHomePage -> DeviceView
        break;
      default:
        body = const Home();
    }
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Modular.to.navigate('/home/reminder');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Appointment'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Modular.to.navigate('/home/appointment');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Parental'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Modular.to.navigate('/home/parental/list');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Device'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Modular.to.navigate('/home/device');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: appBars[_selectedIndex],
      body: body,
      bottomNavigationBar: SizedBox(
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
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
                      Modular.to.navigate('/home/reminder');
                    },
                    icon: Image.asset(
                      _selectedIndex == 0
                          ? 'assets/icons/home-selected.png'
                          : 'assets/icons/home.png',
                      width: 24,
                      color: _selectedIndex == 0 ? kPrimaryColor : Colors.black,
                    ),
                    label: 'Home',
                    isSelected: _selectedIndex == 0,
                  ),
                  CustomIconButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      Modular.to.navigate('/home/appointment');
                    },
                    icon: Image.asset(
                      _selectedIndex == 1
                          ? 'assets/icons/calendar-selected.png'
                          : 'assets/icons/calendar.png',
                      width: 24,
                      color: _selectedIndex == 1 ? kPrimaryColor : Colors.black,
                    ),
                    label: 'Appointment',
                    isSelected: _selectedIndex == 1,
                  ),
                  CustomIconButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                      Modular.to.navigate('/home/parental/list');
                    },
                    icon: Image.asset(
                      _selectedIndex == 2
                          ? 'assets/icons/family-selected.png'
                          : 'assets/icons/family.png',
                      width: 24,
                      color: _selectedIndex == 2 ? kPrimaryColor : Colors.black,
                    ),
                    label: 'Parental',
                    isSelected: _selectedIndex == 2,
                  ),
                  CustomIconButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                      Modular.to.navigate('/home/device');
                    },
                    icon: Image.asset(
                      _selectedIndex == 3
                          ? 'assets/icons/pill-dosage-selected.png'
                          : 'assets/icons/pill-dosage.png',
                      width: 24,
                      color: _selectedIndex == 3 ? kPrimaryColor : Colors.black,
                      height: 24,
                    ),
                    label: 'Device',
                    isSelected: _selectedIndex == 3,
                  ),
                ],
              ),
            ),
          ],
        ),
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
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.icon,
            Text(
              widget.label,
              style: TextStyle(
                color: widget.isSelected ? kPrimaryColor : Colors.black,
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ensure the following parts are present in main.dart:
// part 'home/home.dart';
// part 'appointment/appointment.dart';
// part 'parental/list_parental.dart';
// part 'device/device.dart';
