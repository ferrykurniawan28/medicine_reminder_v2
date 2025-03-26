part of '../main.dart';

void addMedicine(BuildContext ctx) {
  showModalBottomSheet(
    context: ctx,
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(
    //     top: Radius.circular(20),
    //   ),
    // ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Medicine',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            spacerHeight(16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Medicine Name',
                hintText: 'Enter medicine name',
              ),
            ),
            spacerHeight(16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Dosage',
                hintText: 'Enter dosage',
              ),
            ),
            spacerHeight(16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Frequency',
                hintText: 'Enter frequency',
              ),
            ),
            spacerHeight(16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Duration',
                hintText: 'Enter duration',
              ),
            ),
            spacerHeight(16),
            ElevatedButton(
              onPressed: () {
                // Handle add medicine
              },
              child: Text('Add Medicine'),
            ),
          ],
        ),
      );
    },
  );
}

void selectDialog(BuildContext ctx, ContainerModel container) {
  AwesomeDialog(
    context: ctx,
    dialogType: DialogType.noHeader,
    animType: AnimType.scale,
    title: 'Container ${container.id! + 1}',
    desc: 'What would you like to do?',
    btnCancelText: 'Reset',
    btnOkText: 'Refill',
    btnCancelOnPress: () {
      resetDialog(ctx, container);
    },
    btnOkOnPress: () {
      // Handle update action
      print('Update action selected');
    },
  ).show();
}

void resetDialog(BuildContext ctx, ContainerModel container) {
  AwesomeDialog(
    context: ctx,
    dialogType: DialogType.warning,
    animType: AnimType.scale,
    title: 'Reset Container',
    desc: 'Are you sure you want to reset container ${container.id}?',
    btnCancelText: 'Cancel',
    btnOkText: 'Reset',
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      print("ResetContainer event sent for ID: ${container.containerId}");
      ctx.read<DeviceBloc>().add(ResetContainer(container.containerId!));
    },
  ).show();
}

void refillDialog(BuildContext ctx, ContainerModel container) {
  AwesomeDialog(
    context: ctx,
    dialogType: DialogType.info,
    animType: AnimType.scale,
    title: 'Refill Container',
    desc: 'How many items would you like to refill?',
    btnCancelText: 'Cancel',
    btnOkText: 'Refill',
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      // Handle refill action
      print('Refill action selected');
    },
  ).show();
}

void poopUpMenuContainer(
    BuildContext ctx, ContainerModel container, GlobalKey key) {
  final RenderBox? renderBox =
      key.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return; // Prevent crashes

  final Offset offset = renderBox.localToGlobal(Offset.zero);
  final double popupHeight = 0; // Estimated popup height (adjust as needed)

  PopupMenu menu = PopupMenu(
    context: ctx,
    config: const MenuConfig(
      backgroundColor: Colors.green,
      lineColor: Colors.greenAccent,
      highlightColor: Colors.lightGreenAccent,
    ),
    items: [
      PopUpMenuItem(
        title: 'Reset',
        image: const Icon(Icons.refresh),
      ),
      PopUpMenuItem(
        title: 'Change',
        image: const Icon(Icons.edit),
      ),
      PopUpMenuItem(
        title: 'Refill',
        image: const Icon(Icons.add),
      ),
    ],
    onClickMenu: (PopUpMenuItemProvider item) {
      if (item.menuTitle == 'Reset') {
        resetDialog(ctx, container);
      } else if (item.menuTitle == 'Refill') {
        refillDialog(ctx, container);
      }
    },
  );

  menu.show(
    rect: Rect.fromLTWH(
      offset.dx,
      offset.dy - popupHeight, // Move the popup ABOVE the item
      renderBox.size.width,
      renderBox.size.height,
    ),
  );
}
