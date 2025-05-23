import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_modular/flutter_modular.dart'
    show Modular, RouterOutlet;
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';
import 'package:medicine_reminder/features/features.dart';
import 'package:medicine_reminder/features/reminder/presentation/reminder_list_body.dart';
import 'package:medicine_reminder/models/models.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/widgets.dart';
part 'main_page.dart';
part 'home/home.dart';
part 'appointment/appointment.dart';
part 'device/device.dart';
part 'device/your_device.dart';
part 'parental/list_parental.dart';
part 'parental/parental_detail.dart';
part 'parental/parental.dart';
