part of '../widgets.dart';

class MoreOptionsPage extends StatefulWidget {
  final DeviceContainer container;
  const MoreOptionsPage({super.key, required this.container});

  @override
  State<MoreOptionsPage> createState() => _MoreOptionsPageState();
}

class _MoreOptionsPageState extends State<MoreOptionsPage> {
  int? optionIndex;
  int multipleTimesDaily = 3;
  int intervalDays = 3;
  int intervalHours = 6;
  int intakeDays = 21;
  int pauseDays = 7;
  bool multpleTimesDaily = false;
  bool intervalDaysSelect = false;
  bool intervalRemindEvery = false;
  bool intakeDaysSelect = false;
  bool pauseDaysSelect = false;

  Map<Days, bool> daysOfWeek = {
    Days.sunday: false,
    Days.monday: true,
    Days.tuesday: false,
    Days.wednesday: true,
    Days.thursday: false,
    Days.friday: true,
    Days.saturday: false,
  };

  final Color _selectedColor = const Color(0xFF6D4C41); // Dark brown
  final Color _unselectedColor = const Color(0xFFD7CCC8); // Light grey/brown
  final Color _textColor = const Color(0xFF5D4037); // Dark brown for text

  Widget _moreOptionTile({
    required String label,
    required String subLabel,
    required Widget expanded,
    required int index,
  }) {
    return CupertinoListSection.insetGrouped(
      children: [
        CupertinoListTile(
          title: Text(label),
          subtitle: Text(
            subLabel,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            maxLines: 1,
          ),
          trailing: CupertinoSwitch(
            value: optionIndex == index,
            onChanged: (value) {
              setState(() {
                optionIndex = value ? index : null;
              });
            },
          ),
        ),
        if (optionIndex == index)
          CupertinoListTile(
            title: expanded,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: kPrimaryColor,
      navigationBar: defaultCupertinoAppBar('More Options'),
      child: SafeArea(
        child: Stack(
          children: [
            CupertinoListSection.insetGrouped(
              header: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.container.medicineName ?? 'Empty',
                    style: captionTextStyle,
                  ),
                  Text(
                    'Which of these options works for your medication schedule?',
                    style: bodyTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
              children: [
                _moreOptionTile(
                  label: 'Multiple times daily',
                  subLabel: 'e.g 3 or more times a day',
                  index: 0,
                  expanded: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Intakes',
                              style: bodyTextStyle,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {
                                    multpleTimesDaily = !multpleTimesDaily;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.brown.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '$multipleTimesDaily',
                                      style: bodyTextStyle.copyWith(
                                          color: Colors.brown),
                                    ),
                                  ),
                                ),
                                spacerWidth(8),
                                Text(
                                  'times daily',
                                  style: bodyTextStyle,
                                )
                              ],
                            ),
                          ],
                        ),
                        if (multpleTimesDaily)
                          Container(
                            height: 150,
                            padding: const EdgeInsets.only(top: 6),
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            color: CupertinoColors.systemBackground
                                .resolveFrom(context),
                            child: CupertinoPicker(
                              itemExtent: 32.0,
                              scrollController: FixedExtentScrollController(
                                initialItem: multipleTimesDaily - 3,
                              ),
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  multipleTimesDaily = index + 3;
                                });
                              },
                              children: List<Widget>.generate(
                                8,
                                (int index) => Center(
                                  child: Text(
                                    '${index + 3}',
                                    style: bodyTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                // _moreOptionTile(
                //   label: 'Interval',
                //   subLabel: 'e.g once every second day, once every 6 hours',
                //   index: 1,
                //   expanded: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             GestureDetector(
                //               onTap: () => setState(() {
                //                 intervalDaysSelect = false;
                //                 intervalRemindEvery = false;
                //               }),
                //               child: Container(
                //                 padding: const EdgeInsets.symmetric(
                //                   horizontal: 8,
                //                   vertical: 4,
                //                 ),
                //                 decoration: BoxDecoration(
                //                   color: intervalDaysSelect
                //                       ? Colors.grey.withOpacity(0.3)
                //                       : Colors.brown.withOpacity(0.1),
                //                   borderRadius: BorderRadius.circular(8),
                //                 ),
                //                 child: Text(
                //                   'Every X hours',
                //                   style: bodyTextStyle.copyWith(
                //                     color: intervalDaysSelect
                //                         ? Colors.grey
                //                         : Colors.brown,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             spacerWidth(8),
                //             GestureDetector(
                //               onTap: () => setState(() {
                //                 intervalDaysSelect = true;
                //                 intervalRemindEvery = false;
                //               }),
                //               child: Container(
                //                 padding: const EdgeInsets.symmetric(
                //                   horizontal: 8,
                //                   vertical: 4,
                //                 ),
                //                 decoration: BoxDecoration(
                //                   color: intervalDaysSelect
                //                       ? Colors.brown.withOpacity(0.1)
                //                       : Colors.grey.withOpacity(0.3),
                //                   borderRadius: BorderRadius.circular(8),
                //                 ),
                //                 child: Text(
                //                   'Every X Days',
                //                   style: bodyTextStyle.copyWith(
                //                     color: intervalDaysSelect
                //                         ? Colors.brown
                //                         : Colors.grey,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //         spacerHeight(8),
                //         Row(
                //           children: [
                //             Text('Remind every',
                //                 style: bodyTextStyle.copyWith()),
                //             const Spacer(),
                //             Row(
                //               children: [
                //                 GestureDetector(
                //                   onTap: () => setState(() {
                //                     intervalRemindEvery = !intervalRemindEvery;
                //                   }),
                //                   child: Container(
                //                     padding: const EdgeInsets.symmetric(
                //                       horizontal: 8,
                //                       vertical: 4,
                //                     ),
                //                     decoration: BoxDecoration(
                //                       color: Colors.brown.withOpacity(0.1),
                //                       borderRadius: BorderRadius.circular(8),
                //                     ),
                //                     child: Text(
                //                       intervalDaysSelect
                //                           ? '$intervalDays'
                //                           : '$intervalHours',
                //                       style: bodyTextStyle.copyWith(
                //                         color: Colors.brown,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //                 spacerWidth(8),
                //                 Text(
                //                   intervalDaysSelect ? 'days' : 'hours',
                //                   style: bodyTextStyle,
                //                 ),
                //               ],
                //             )
                //           ],
                //         ),
                //         if (intervalRemindEvery)
                //           Container(
                //             height: 150,
                //             padding: const EdgeInsets.only(top: 6),
                //             margin: EdgeInsets.only(
                //               bottom: MediaQuery.of(context).viewInsets.bottom,
                //             ),
                //             color: CupertinoColors.systemBackground
                //                 .resolveFrom(context),
                //             child: CupertinoPicker(
                //               itemExtent: 32.0,
                //               scrollController: FixedExtentScrollController(
                //                 initialItem: intervalDaysSelect
                //                     ? intervalDays - 2
                //                     : intervalHours - 1,
                //               ),
                //               onSelectedItemChanged: (int index) {
                //                 setState(() {
                //                   if (intervalDaysSelect) {
                //                     intervalDays = index + 2;
                //                   } else {
                //                     intervalHours = index + 1;
                //                   }
                //                 });
                //               },
                //               children: List<Widget>.generate(
                //                 intervalDaysSelect ? 14 : 12,
                //                 (int index) => Center(
                //                   child: Text(
                //                     '${intervalDaysSelect ? index + 2 : index + 1}',
                //                     style: bodyTextStyle,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //       ],
                //     ),
                //   ),
                // ),
                _moreOptionTile(
                  label: 'Specific days of the week',
                  subLabel: 'e.g Mon, Wed, & Fri',
                  index: 2,
                  expanded: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio:
                                  0.6, // Better aspect ratio for the items
                            ),
                            itemCount: Days.values.length,
                            itemBuilder: (context, index) {
                              final day = Days.values[index];
                              final isSelected = daysOfWeek[day] ?? false;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? _selectedColor.withOpacity(0.1)
                                      : _unselectedColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? _selectedColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: _selectedColor.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() {
                                        daysOfWeek[day] = !isSelected;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 150),
                                          opacity: isSelected ? 1 : 0,
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            color: _selectedColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          day.name
                                              .substring(0, 3)
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? _selectedColor
                                                : _textColor.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // _moreOptionTile(
                //   label: 'Cyclic mode',
                //   subLabel: 'e.g 21 intake days, 7 pause days',
                //   index: 3,
                //   expanded: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Text(
                //               'Intake days',
                //               style: bodyTextStyle,
                //             ),
                //             const Spacer(),
                //             Row(
                //               children: [
                //                 GestureDetector(
                //                   onTap: () => setState(() {
                //                     pauseDaysSelect = false;
                //                     intakeDaysSelect = !intakeDaysSelect;
                //                   }),
                //                   child: Container(
                //                     padding: const EdgeInsets.symmetric(
                //                       horizontal: 8,
                //                       vertical: 4,
                //                     ),
                //                     decoration: BoxDecoration(
                //                       color: Colors.brown.withOpacity(0.1),
                //                       borderRadius: BorderRadius.circular(8),
                //                     ),
                //                     child: Text(
                //                       '$intakeDays',
                //                       style: bodyTextStyle.copyWith(
                //                           color: Colors.brown),
                //                     ),
                //                   ),
                //                 ),
                //                 spacerWidth(8),
                //                 Text(
                //                   'days',
                //                   style: bodyTextStyle,
                //                 )
                //               ],
                //             ),
                //           ],
                //         ),
                //         if (intakeDaysSelect)
                //           Container(
                //             height: 150,
                //             padding: const EdgeInsets.only(top: 6),
                //             margin: EdgeInsets.only(
                //               bottom: MediaQuery.of(context).viewInsets.bottom,
                //             ),
                //             color: CupertinoColors.systemBackground
                //                 .resolveFrom(context),
                //             child: CupertinoPicker(
                //               itemExtent: 32.0,
                //               scrollController: FixedExtentScrollController(
                //                 initialItem: intakeDays - 2,
                //               ),
                //               onSelectedItemChanged: (int index) {
                //                 setState(() {
                //                   intakeDays = index + 2;
                //                 });
                //               },
                //               children: List<Widget>.generate(
                //                 60,
                //                 (int index) => Center(
                //                   child: Text(
                //                     '${index + 2}',
                //                     style: bodyTextStyle,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         spacerHeight(8),
                //         Row(
                //           children: [
                //             Text(
                //               'Pause days',
                //               style: bodyTextStyle,
                //             ),
                //             const Spacer(),
                //             Row(
                //               children: [
                //                 GestureDetector(
                //                   onTap: () => setState(() {
                //                     intakeDaysSelect = false;
                //                     pauseDaysSelect = !pauseDaysSelect;
                //                   }),
                //                   child: Container(
                //                     padding: const EdgeInsets.symmetric(
                //                       horizontal: 8,
                //                       vertical: 4,
                //                     ),
                //                     decoration: BoxDecoration(
                //                       color: Colors.brown.withOpacity(0.1),
                //                       borderRadius: BorderRadius.circular(8),
                //                     ),
                //                     child: Text(
                //                       '$pauseDays',
                //                       style: bodyTextStyle.copyWith(
                //                           color: Colors.brown),
                //                     ),
                //                   ),
                //                 ),
                //                 spacerWidth(8),
                //                 Text(
                //                   'days',
                //                   style: bodyTextStyle,
                //                 )
                //               ],
                //             ),
                //           ],
                //         ),
                //         if (pauseDaysSelect)
                //           Container(
                //             height: 150,
                //             padding: const EdgeInsets.only(top: 6),
                //             margin: EdgeInsets.only(
                //               bottom: MediaQuery.of(context).viewInsets.bottom,
                //             ),
                //             color: CupertinoColors.systemBackground
                //                 .resolveFrom(context),
                //             child: CupertinoPicker(
                //               itemExtent: 32.0,
                //               scrollController: FixedExtentScrollController(
                //                 initialItem: pauseDays - 2,
                //               ),
                //               onSelectedItemChanged: (int index) {
                //                 setState(() {
                //                   pauseDays = index + 2;
                //                 });
                //               },
                //               children: List<Widget>.generate(
                //                 60,
                //                 (int index) => Center(
                //                   child: Text(
                //                     '${index + 2}',
                //                     style: bodyTextStyle,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: CupertinoButton.filled(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sizeStyle: CupertinoButtonSize.medium,
                  onPressed: optionIndex != null
                      ? () {
                          switch (optionIndex) {
                            case 0:
                              Modular.to.pushNamed('/reminder/multiple-times',
                                  arguments: {
                                    'container': widget.container,
                                    'howManyTimes': multipleTimesDaily
                                  });
                              break;
                            case 1:
                              //
                              break;
                            case 2:
                              List<Days> selectedDays = daysOfWeek.entries
                                  .where((entry) => entry.value)
                                  .map((entry) => entry.key)
                                  .toList();
                              Modular.to.pushNamed('/reminder/specific-days',
                                  arguments: {
                                    'container': widget.container,
                                    'days': selectedDays,
                                  });
                            default:
                          }
                        }
                      : null,
                  child: const Text('Next'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
