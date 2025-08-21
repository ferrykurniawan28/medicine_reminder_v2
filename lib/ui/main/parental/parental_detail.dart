part of '../main.dart';

class ParentalDetail extends StatefulWidget {
  final Parental parental;
  const ParentalDetail({super.key, required this.parental});

  @override
  State<ParentalDetail> createState() => _ParentalDetailState();
}

class _ParentalDetailState extends State<ParentalDetail> {
  int _selectedSegment = 0;

  @override
  void initState() {
    super.initState();
    Modular.to.pushNamed('/parental/detail/', arguments: {
      'parental': widget.parental,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        widget.parental.user.userName!,
        actions: [],
        leading: IconButton(
          onPressed: () {
            // Find the main page and trigger proper navigation
            Navigator.of(context).popUntil((route) {
              // Pop until we reach the main page route
              UserHelper.executeWithUserId(context, (int userId) {
                context.read<ParentalBloc>().add(LoadParentals(userId));
              });
              return route.settings.name == '/home' || route.isFirst;
            });
            // Navigator.of(context).popUntil((route) {
            //   // Pop until we reach the main page route
            //   return route.settings.name == '/home' || route.isFirst;
            // });
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();

            // Then navigate to parental with proper state update
            // Future.delayed(const Duration(milliseconds: 500), () {
            //   Modular.to.navigate('/home/parental');
            // });
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const RouterOutlet(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedSegment,
                children: const {
                  0: Text('Reminder'),
                  1: Text('Appointment'),
                  2: Text('Device'),
                },
                onValueChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      _selectedSegment = value;
                    });
                    switch (value) {
                      case 0:
                        Modular.to.pushNamed('/parental/detail/', arguments: {
                          'parental': widget.parental,
                        });
                        break;
                      case 1:
                        Modular.to.pushNamed('/parental/detail/appointment',
                            arguments: {
                              'parental': widget.parental,
                            });
                        break;
                      case 2:
                        Modular.to
                            .pushNamed('/parental/detail/device', arguments: {
                          'parental': widget.parental,
                        });
                        break;
                    }
                  }
                },
              ),
            ),
          ),

          // const Expanded(child: RouterOutlet()),
        ],
      ),
      floatingActionButton: _selectedSegment <= 1
          ? FloatingActionButton(
              onPressed: () {},
              shape: const CircleBorder(),
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
