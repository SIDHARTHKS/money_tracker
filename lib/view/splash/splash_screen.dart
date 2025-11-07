import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/gen/assets.gen.dart';
import 'package:tracker/helper/sizer.dart';
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
              return Center(
                child: appText('Error: ${snapshot.error}',
                    color: AppColorHelper().primaryTextColor),
              );
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

  SizedBox _loaderWidget() {
    final colorHelper = AppColorHelper();
    return appContainer(
      enableSafeArea: false,
      child: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     colorHelper.cardColor.withOpacity(0.95),
          //     colorHelper.cardColor.withOpacity(0.85),
          //     colorHelper.cardColor.withOpacity(0.8),
          //     colorHelper.cardColor.withOpacity(0.6),
          //     colorHelper.cardColor.withOpacity(0.5),
          //   ],
          // ),
          color: AppColorHelper().cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // App Logo or Centered Loader
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Optional app logo
                  Image.asset(Assets.icon.path, height: 280),
                  // Lottie.asset(
                  //   'assets/lottie/loading.json',
                  //   fit: BoxFit.contain,
                  //   repeat: true,
                  //   height: 180,
                  //   width: 180,
                  // ),
                  height(20),
                  appText(
                    "Loading...",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorHelper.primaryTextColor.withOpacity(0.8),
                  ),
                ],
              ),
            ),
            // Optional bottom gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorHelper.cardColor.withOpacity(0.0),
                      colorHelper.cardColor.withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
