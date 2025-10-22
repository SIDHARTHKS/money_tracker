import 'package:flutter/material.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:tracker/tracker_app.dart';
import 'helper/core/environment/env.dart';
import 'helper/enum.dart';
import 'helper/init/app_init.dart';

void main() async {
  AppEnvironment.setEnv(Environment.UAT);
  AppEnvironment.setClient(AppClient.kalyan);
  await AppInit().mainInit();
  runApp(const TrackerApp());
}
