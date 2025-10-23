import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controller/splash_controller.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../helper/navigation.dart';
import '../../helper/route.dart';
import '../widget/common_widget.dart';

class SplashScreen extends AppBaseView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Scaffold _widgetView() => appScaffold(
        extendBody: true,
        topSafe: false,
        body: appFutureBuilder<int>(
          () => controller.fetchUserProfile(),
          (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loaderWidget();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigateToAndRemoveAll(
                  snapshot.data == 1 ? homePageRoute : landingPageRoute,
                );
              });
              return _loaderWidget();
            } else {
              return _loaderWidget();
            }
          },
          loaderWidget: _loaderWidget(),
        ),
      );

  SizedBox _loaderWidget() => appContainer(
        enableSafeArea: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColorHelper()
                .primaryColor
                .withValues(alpha: 0.6), /////////0.6
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: Get.height * 0.35,
                child: Column(
                  children: [
                    Lottie.asset('assets/lottie/loading.json',
                        fit: BoxFit.contain,
                        repeat: true,
                        height: 200,
                        width: 200),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
