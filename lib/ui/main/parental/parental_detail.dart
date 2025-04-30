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
    Modular.to.navigate('/home/parental/detail/reminder', arguments: {
      'parental': widget.parental,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        widget.parental.user.userName,
        actions: [],
        leading: IconButton(
          onPressed: () {
            Modular.to.navigate('/home/parental/list');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: CupertinoSlidingSegmentedControl<int>(
              groupValue: _selectedSegment,
              children: const {
                0: Text('Reminder'),
                1: Text('Appointment'),
                2: Text('Device'),
              },
              onValueChanged: (int? value) {
                setState(() {
                  _selectedSegment = value!;
                });
                switch (value) {
                  case 0:
                    Modular.to
                        .navigate('/home/parental/detail/reminder', arguments: {
                      'parental': widget.parental,
                    });
                    break;
                  case 1:
                    Modular.to.navigate('/home/parental/detail/appointment',
                        arguments: {
                          'parental': widget.parental,
                        });
                    break;
                  case 2:
                    Modular.to
                        .navigate('/home/parental/detail/device', arguments: {
                      'parental': widget.parental,
                    });
                    break;
                }
              },
            ),
          ),
          const Expanded(child: RouterOutlet()),
        ],
      ),
      floatingActionButton: _selectedSegment <= 1
          ? FloatingActionButton(
              onPressed: () {},
              shape: const CircleBorder(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
