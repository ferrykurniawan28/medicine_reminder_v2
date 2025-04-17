part of '../widgets.dart';

void addMedicine(BuildContext ctx, ContainerModel container) {
  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    builder: (context) => _MedicineForm(container: container),
  );
}

class _MedicineForm extends StatefulWidget {
  final ContainerModel container;
  const _MedicineForm({required this.container});

  @override
  _MedicineFormState createState() => _MedicineFormState();
}

class _MedicineFormState extends State<_MedicineForm> {
  late final medicineNameController = TextEditingController();
  late final dosageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    medicineNameController.text = widget.container.medicineName ?? '';
    dosageController.text = (widget.container.quantity != null)
        ? widget.container.quantity.toString()
        : '';
    super.initState();
  }

  @override
  void dispose() {
    medicineNameController.dispose();
    dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Medicine',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: medicineNameController,
                    decoration: const InputDecoration(
                      labelText: 'Medicine Name',
                      hintText: 'Enter medicine name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter medicine name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: dosageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      hintText: 'Enter quantity',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      } else if (int.tryParse(value) == null) {}
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<DeviceBloc>().add(
                              UpdateContainer(
                                containerId: widget.container.containerId,
                                medicineName: medicineNameController.text,
                                quantity: int.parse(dosageController.text),
                              ),
                            );
                        Modular.to.pop();
                      }
                    },
                    child: const Text('Add Medicine'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
      ctx.read<DeviceBloc>().add(ResetContainer(container.containerId));
    },
  ).show();
}

void poopUpMenuContainer(
    BuildContext ctx, ContainerModel container, GlobalKey key) {
  final RenderBox? renderBox =
      key.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return; // Prevent crashes

  final Offset offset = renderBox.localToGlobal(Offset.zero);
  const double popupHeight = 0;

  PopupMenu menu = PopupMenu(
    context: ctx,
    config: const MenuConfig(
      backgroundColor: Colors.blue,
      // lineColor: Colors.greenAccent,
      highlightColor: Colors.lightGreenAccent,
    ),
    items: [
      PopUpMenuItem(
        title: 'Reset',
        image: const Icon(Icons.refresh),
      ),
      PopUpMenuItem(
        title: 'Add/Refill',
        image: const Icon(Icons.add_circle_outline),
      ),
    ],
    onClickMenu: (PopUpMenuItemProvider item) {
      if (item.menuTitle == 'Reset') {
        resetDialog(ctx, container);
      } else if (item.menuTitle == 'Add/Refill') {
        addMedicine(ctx, container);
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
