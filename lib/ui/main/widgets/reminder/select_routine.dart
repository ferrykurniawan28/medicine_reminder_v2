part of '../widgets.dart';

class RoutineSelectionScreen extends StatelessWidget {
  final User assignedUser;
  final DeviceContainer container;
  final bool isParental;

  const RoutineSelectionScreen(
      {super.key,
      required this.container,
      required this.assignedUser,
      required this.isParental});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: kPrimaryColor,
      // backgroundColor:
      //     CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: defaultCupertinoAppBar('Select Routine'),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                container.medicineName ?? 'Empty',
                style: captionTextStyle.copyWith(),
              ),
              Text(
                'How often do you take this medication?',
                style: bodyTextStyle,
              ),
            ],
          ),
          children: [
            CupertinoListTile(
              title: const Text('Once Daily'),
              onTap: () => Modular.to.pushNamed(
                '/reminder/once-twice',
                arguments: {
                  'container': container,
                  'isOnce': true,
                  'assignedUser': assignedUser,
                  'isParental': isParental,
                },
              ),
            ),
            CupertinoListTile(
              title: const Text('Twice Daily'),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => OnceTwiceDailyPage(
                      container: container,
                      isOnce: false,
                      assignedUser: assignedUser,
                      isParental: isParental,
                    ),
                  ),
                );
              },
            ),
            CupertinoListTile(
              title: const Text('More options...'),
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MoreOptionsPage(
                    container: container,
                    assignedUser: assignedUser,
                    isParental: isParental,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
