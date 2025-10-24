import 'package:flutter/material.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'package:tracker/tracker_app.dart';
import 'helper/core/environment/env.dart';
import 'helper/enum.dart';
import 'helper/init/app_init.dart';

void main() async {
  AppEnvironment.setEnv(Environment.DEV);
  AppEnvironment.setClient(AppClient.sid);
  await AppInit().mainInit();
  runApp(const TrackerApp());
}
