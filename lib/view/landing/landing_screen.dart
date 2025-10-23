import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/controller/landing_controller.dart';

import 'package:tracker/helper/color_helper.dart';
import 'package:tracker/helper/navigation.dart';
import 'package:tracker/helper/route.dart';
import '../../helper/core/base/app_base_view.dart';
import '../widget/common_widget.dart';

class LandingScreen extends AppBaseView<LandingController> {
  const LandingScreen({super.key});

  @override
  Widget buildView() {
    return appScaffold(
      canpop: false,
      extendBodyBehindAppBar: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: appContainer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

            return AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: keyboardHeight),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Obx(() {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.08),
                          Center(
                            child: Lottie.asset(
                              'assets/lottie/landing.json',
                              fit: BoxFit.contain,
                              height: Get.height * 0.35,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Discover a \nway to manage \nyour ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800,
                                      color: AppColorHelper().primaryTextColor,
                                      height: 1.2,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "finance",
                                    style: GoogleFonts.poppins(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800,
                                      color: AppColorHelper().primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32, top: 40),
                            child: SizedBox(
                              height: 72,
                              child: TextField(
                                controller: controller.userController,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.name,
                                cursorColor: AppColorHelper().primaryColor,
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColorHelper().primaryTextColor,
                                ),
                                decoration: InputDecoration(
                                  hintText: controller.userError.value == ""
                                      ? "Enter your name"
                                      : controller.userError.value,
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: AppColorHelper()
                                        .primaryTextColor
                                        .withOpacity(0.4),
                                  ),
                                  filled: true,
                                  fillColor: AppColorHelper()
                                      .primaryColor
                                      .withValues(alpha: 0.1),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (controller.validateUser()) {
                                          await controller.savePreference();
                                          // controller.setUser(); // if you also want Hive save
                                          navigateToAndRemoveAll(homePageRoute);
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: AppColorHelper().primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppColorHelper().textColor,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
