import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:medicine_reminder/features/device/bloc/device_bloc.dart';
import 'package:medicine_reminder/extensions/extensions.dart';
import 'package:medicine_reminder/features/parental/bloc/parental_bloc.dart';
import 'package:medicine_reminder/features/parental/models/models.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/features/device/models/models.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'widgets/widgets.dart';

part 'main_page.dart';
part 'home/home.dart';
part 'calendar/calendar.dart';
part 'group/group.dart';
part 'device/device.dart';
part 'device/add_medicine.dart';
part 'device/list_device.dart';
part 'group/list_group.dart';
