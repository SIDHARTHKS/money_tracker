import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/controller/landing_controller.dart';
import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/navigation.dart';
import 'package:tracker/helper/route.dart';
import 'package:tracker/helper/sizer.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import '../../helper/core/base/app_base_view.dart';
import '../widget/common_widget.dart';

class LandingScreen extends AppBaseView<LandingController> {
  const LandingScreen({super.key});

  @override
  Widget buildView() {
    return appScaffold(
      canpop: false,
      extendBodyBehindAppBar: true,
      body: const _AnimatedLandingBody(),
    );
  }
}

class _AnimatedLandingBody extends StatefulWidget {
  const _AnimatedLandingBody();

  @override
  State<_AnimatedLandingBody> createState() => _AnimatedLandingBodyState();
}

class _AnimatedLandingBodyState extends State<_AnimatedLandingBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final colorHelper = AppColorHelper();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = (1 - (_controller.value * 2 - 1).abs()) * 0.3;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + offset, -1),
              end: Alignment(1 - offset, 1),
              colors: isDark
                  ? [
                      Colors.black.withOpacity(0.95),
                      Colors.black.withOpacity(0.95),
                      colorHelper.primaryColorDark.withOpacity(0.1),
                    ]
                  : [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.9),
                      colorHelper.primaryColorLight.withOpacity(0.6),
                    ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Obx(() {
                  final controller = Get.find<LandingController>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(250),

                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 800),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Discover a new\nway to manage\n",
                                style: GoogleFonts.poppins(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: colorHelper.primaryTextColor,
                                  height: 1.2,
                                ),
                              ),
                              TextSpan(
                                text: "your finance",
                                style: GoogleFonts.poppins(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color:
                                      colorHelper.primaryColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      height(60),

                      // Input Field with Glass Button
                      Container(
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColorHelper()
                              .primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColorHelper()
                                  .borderColor
                                  .withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.userController,
                                style: textStyle(
                                  18,
                                  colorHelper.primaryTextColor,
                                  FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: controller.userError.value == ""
                                      ? "Enter your name"
                                      : controller.userError.value,
                                  hintStyle: GoogleFonts.inter(
                                    color: colorHelper.primaryTextColor
                                        .withOpacity(0.6),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 18),
                                ),
                              ),
                            ),
                            width(8),
                            GestureDetector(
                              onTap: () async {
                                if (controller.validateUser()) {
                                  await controller.savePreference();
                                  navigateToAndRemoveAll(homePageRoute);
                                }
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colorHelper.primaryColor
                                          .withOpacity(0.95),
                                      colorHelper.primaryColor.withOpacity(0.2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColorHelper()
                                          .primaryColor
                                          .withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: colorHelper.primaryTextColor,
                                  size: 26,
                                ),
                              ),
                            ),
                            width(8),
                          ],
                        ),
                      ),
                      height(40),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
