import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controller/splash_controller.dart';
import '../../helper/core/base/app_base_view.dart';

import '../widget/common_widget.dart';

class LandingScreen extends AppBaseView<SplashController> {
  const LandingScreen({super.key});

  @override
  Widget buildView() {
    return appScaffold(
      canpop: true,
      extendBodyBehindAppBar: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: () async {
          return;
        },
        child: appContainer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/landing.json',
                  fit: BoxFit.contain,
                  repeat: true,
                  height: 400,
                  width: 400,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
