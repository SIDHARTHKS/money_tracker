import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tracker/helper/route.dart';
import '../../gen/assets.gen.dart';
import '../../helper/app_string.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/environment/env.dart';
import '../../helper/date_helper.dart';
import '../../helper/enum.dart';
import '../../helper/navigation.dart';
import '../../helper/sizer.dart';
import 'text/app_text.dart';
import 'dart:math' as math;

Scaffold appScaffold(
        {required Widget body,
        bool loaderEnabled = true,
        bool showLoader = false,
        AppBar? appBar,
        bool resizeToAvoidBottomInset = false,
        Widget? bottomNavigationBar,
        Widget? drawer,
        extendBodyBehindAppBar = true,
        extendBody = true,
        bool isTransparent = false,
        bool topSafe = true,
        VoidCallback? action,
        bool? canpop,
        Color? bgcolor,
        FloatingActionButton? floatingActionButton}) =>
    Scaffold(
      extendBody: extendBody,
      drawerEnableOpenDragGesture: false,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: bgcolor ?? AppColorHelper().backgroundColor,
      body: SafeArea(
        top: topSafe, // Set to true if you want to avoid notch overlap too
        bottom: false, //
        child: PopScope(
          canPop: canpop ?? true,
          onPopInvokedWithResult: (didpop, result) {
            if (action != null) {
              action!(); // execute regardless of pop result
            }
          },
          child: loaderEnabled
              ? Stack(
                  children: [
                    body,
                    if (showLoader)
                      Positioned.fill(
                        child: Container(
                          color: AppColorHelper().loaderColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // logoImage(),
                              loader(),
                            ],
                          ),
                        ),
                      )
                  ],
                )
              : body,
        ),
      ),
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
AppBar appBar({
  bool showbackArrow = true,
  Widget? leadingWidget,
  List<Widget>? actions,
  String? titleText,
  VoidCallback? leadingWidgetPressed,
  VoidCallback? refreshPressed,
}) {
  bool isTablet = AppEnvironment.deviceType == UserDeviceType.tablet;

  // Updated leading widget with perfect circle + left padding
  leadingWidget = Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(),
      child: Center(
        child: leadingWidget ??
            Icon(
              Icons.arrow_back_ios_new,
              size: 30,
              color: AppColorHelper().primaryTextColor,
            ),
      ),
    ),
  );

  // Environment label
  if (!AppEnvironment.isProdMode()) {
    actions ??= [];
    actions.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: boldLabelText(
          AppEnvironment.isDevMode() ? 'DEV' : 'UAT',
          color: AppColorHelper().primaryTextColor.withOpacity(.1),
        ),
      ),
    );
  }

  // Refresh icon
  if (refreshPressed != null) {
    actions ??= [];
    actions.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          onTap: refreshPressed,
          child: iconWidget(
            Icons.refresh,
            color: AppColorHelper().textColor,
          ),
        ),
      ),
    );
  }

  return AppBar(
    scrolledUnderElevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: AppColorHelper().tabbarBgClr,
      statusBarColor: AppColorHelper().transparentColor,
    ),
    backgroundColor: AppColorHelper().backgroundColor,
    automaticallyImplyLeading: false,
    leadingWidth: showbackArrow ? 60 : 60,
    leading: showbackArrow
        ? GestureDetector(
            onTap: () {
              if (leadingWidgetPressed != null) {
                leadingWidgetPressed();
              } else {
                goBack();
              }
            },
            child: leadingWidget,
          )
        : const SizedBox.shrink(),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        appText(
          titleText ?? '',
          fontSize: isTablet ? 30 : 22,
          fontWeight: FontWeight.w700,
          color: AppColorHelper().primaryTextColor,
        ),
        width(AppEnvironment.isProdMode() ? 55 : 10),
      ],
    ),
    actions: actions,
  );
}

customAppBar(String title, String subtitle, {VoidCallback? onTap}) => AppBar(
      toolbarHeight: 70,
      backgroundColor: AppColorHelper().backgroundColor,
      titleSpacing: 0,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColorHelper()
                              .borderColor
                              .withValues(alpha: 0.15)),
                      color: AppColorHelper()
                          .backgroundColor
                          .withValues(alpha: 0.5)),
                  child: GestureDetector(
                    onTap: onTap,
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  )),
              width(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appText(title,
                      color: AppColorHelper()
                          .primaryTextColor
                          .withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                  // appText(subtitle,
                  //     color: AppColorHelper().textColor.withValues(alpha: 0.9),
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 12),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            navigateTo(savingsPageRoute);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color:
                          AppColorHelper().borderColor.withValues(alpha: 0.11)),
                  color: AppColorHelper().primaryColor.withValues(alpha: 0.17)),
              child: GestureDetector(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 17.0, right: 13.0, top: 13.0, bottom: 13.0),
                    child: Image.asset(
                      Assets.icons.savings.path,
                      color: AppColorHelper().primaryColor,
                    ),
                  )),
            ),
          ),
        ),
      ],
    );

SizedBox appContainerold({
  required Widget child,
  bool enableSafeArea = true,
  String? img,
}) {
  late BoxDecoration boxDecoration;
  boxDecoration = switch (AppEnvironment.appClient) {
    AppClient.kalyan =>
      const BoxDecoration(color: Color.fromRGBO(251, 249, 216, 1)),
    AppClient.muziris =>
      const BoxDecoration(color: Color.fromRGBO(251, 249, 216, 1)),
  };
  return SizedBox(
    height: Get.height,
    width: Get.width,
    child: Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: boxDecoration,
            // child: Image.asset(
            //   img ?? '',
            //   fit: BoxFit.cover,
            //   color: img != null
            //       ? Colors.black.withValues(alpha: 0)
            //       : Colors.black.withValues(alpha: 0.05),
            //   colorBlendMode: BlendMode.colorBurn,
            // ),
          ),
        ),
        enableSafeArea ? SafeArea(child: child) : child,
      ],
    ),
  );
}

SizedBox appContainer(
    {required Widget child,
    bool enableSafeArea = true,
    String? img,
    BoxDecoration? decoration}) {
  late BoxDecoration boxDecoration;
  boxDecoration = BoxDecoration(color: AppColorHelper().backgroundColor);
  return SizedBox(
    height: Get.height,
    width: Get.width,
    child: Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: decoration ?? boxDecoration,
          ),
        ),
        enableSafeArea ? SafeArea(child: child) : child,
      ],
    ),
  );
}

InkWell appIcon({
  required IconData icon,
  Color? color,
  double? size,
  VoidCallback? onPressed,
}) =>
    InkWell(
      onTap: onPressed,
      child: Icon(
        icon,
        color: color ?? Colors.grey,
        size: size ?? 24.0,
      ),
    );

Widget drawerListTile({
  required IconData icon,
  required String title,
  VoidCallback? onTap,
  Widget? trailing,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.purple),
    title: Text(
      title,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    ),
    trailing: trailing,
    onTap: onTap,
  );
}

double responsiveFontSize(double size) {
  // Adjust based on a 375px design width.
  return size * Get.width / 375.0;
}

Padding divider({
  Color? color,
  double indent = 0,
  double endIndent = 0,
}) {
  color ??= AppColorHelper().dividerColor.withOpacity(.5);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Divider(
      color: color,
      indent: indent,
      endIndent: endIndent,
    ),
  );
}

Divider drawerDivider() => const Divider(
      color: Colors.grey,
      thickness: 0.5,
      height: 16.0,
    );

Switch switchWidget(
  bool value, {
  Color? activeColor,
  Function(bool)? onChanged,
}) =>
    Switch(
        activeColor: activeColor ?? AppColorHelper().primaryColor,
        value: value,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged(value);
          }
        });

SizedBox clientLogo({
  double? width = 220,
  double height = 120,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        AppEnvironment.appClient == AppClient.kalyan
            ? Assets.images.kalyanLogo.path
            : Assets.images.kalyanLogo.path,
      ),
    );
SizedBox muzirisLogo({
  double? width = 70,
  double height = 30,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: Image.asset(Assets.images.muzirisLogo.path),
    );

Padding muzBottomLogo() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 25.0),
    child: muzirisLogo(),
  );
}

SizedBox retailLogo({
  double? width = 90,
  double height = 50,
  bool white = false,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: Image.asset(white
          ? Assets.images.kalyanLogo.path
          : Assets.images.kalyanLogo.path),
    );

LoadingIndicator buttonLoader() => LoadingIndicator(
      indicatorType: Indicator.ballClipRotatePulse,
      colors: [AppColorHelper().primaryColor],
    );

LoadingIndicator secondaryLoader() => LoadingIndicator(
      indicatorType: Indicator.circleStrokeSpin,
      colors: [AppColorHelper().primaryColor],
    );
GestureDetector gradientButtonContainer(
  Widget child, {
  double? radius,
  double? width,
  double? height = 60,
  VoidCallback? onPressed,
  List<Color>? gradientColors,
  AlignmentGeometry begin = Alignment.centerLeft,
  AlignmentGeometry end = Alignment.centerRight,
}) =>
    GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 15),
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: gradientColors ??
                const [
                  Color.fromARGB(255, 237, 185, 42), // Gold
                  Color.fromARGB(255, 193, 163, 62), // Warm Brown
                ],
          ),
        ),
        child: child,
      ),
    );

GestureDetector buttonContainer(
  Widget child, {
  double radius = 10,
  double? width,
  double? height = 50,
  // Color? color = const Color(0xffBB2828),
  Color? color,
  VoidCallback? onPressed,
  Color? borderColor = Colors.transparent,
}) =>
    GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
              color: borderColor ??
                  AppColorHelper().primaryTextColor.withValues(alpha: 0.5)),
          color: color ?? AppColorHelper().buttonColor,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.3),
          //     spreadRadius: 2,
          //     blurRadius: 8,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: child,
      ),
    );

Row doubleArrowSfxText(String text) {
  Color color;
  color = switch (AppEnvironment.appClient) {
    AppClient.kalyan => AppColorHelper().textColor,
    AppClient.muziris => AppColorHelper().textColor,
  };
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // tx700(text,
      //     color: const Color(0xff444444),
      //     size: 25,
      //     textAlign: TextAlign.center),
      appBarText(
        text,
        color: color,
        size: 25,
      ),
      Container(
        width: 100,
        height: 30,
        margin: const EdgeInsets.only(top: 4),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: iconWidget(
                  Icons.arrow_forward_ios_sharp,
                  color: color,
                  size: 20,
                ),
              ),
            ),
            Positioned(
              left: 7,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: color.withOpacity(.2),
                  size: 20,
                ),
              ),
            )
          ],
        ),
      )
    ],
  );
}

SizedBox loader() => const SizedBox(
      width: 70,
      height: 40,
      child: LoopingProgressBar(),
    );

Image logoImage() {
  String imagePath = '';
  imagePath = switch (AppEnvironment.appClient) {
    AppClient.muziris => Assets.images.kalyanLogowhite.path,
    AppClient.kalyan => Assets.images.kalyanLogowhite.path,
  };
  return Image.asset(
    imagePath,
    width: 200,
    height: 150,
  );
}

Container fullScreenloader() {
  log("Full-screen loader is being called");
  return Container(
    decoration: BoxDecoration(
      color: AppColorHelper().primaryColor,
      image: DecorationImage(
        image: AssetImage(Assets.images.background.path),
        fit: BoxFit.cover,
        opacity: 0.1,
      ),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Positioned(top: 100, left: 0, right: 0, child: logoImage()),
        Center(child: CircleLoader()),
        height(40),
        Positioned(
          bottom: 300,
          left: 0,
          right: 0,
          child: Column(
            children: [
              appText(
                settingThingsUp.tr,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColorHelper().textColor,
              ),
              height(5),
              appText(
                yourBussinessOverview.tr,
                textAlign: TextAlign.center,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColorHelper().textColor,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Container miniLoader() {
  return Container(
    width: 250,
    height: 250,
    decoration: BoxDecoration(
      color: AppColorHelper().transparentColor, // Semi-transparent background
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        height(20),
        CircularProgressIndicator(
          color: const Color.fromARGB(255, 255, 255, 255),
        )
      ],
    ),
  );
}

FutureBuilder appFutureBuilder<T>(
  Future<T> Function() futureFunction,
  Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      successWidget, {
  Widget? loaderWidget,
}) {
  loaderWidget ??= fullScreenloader();
  return FutureBuilder<T>(
    future: futureFunction(),
    builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return loaderWidget!;
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        return successWidget(context, snapshot);
      }
    },
  );
}

SizedBox bgLoader() => appContainer(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.images.kalyanLogo.path),
                height(10),
                loader(),
              ],
            ),
          ),
        ],
      ),
    );
TextButton textButtonWidget({
  required String text,
  required VoidCallback onPressed,
}) =>
    TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style:
              textStyle(15, AppColorHelper().primaryTextColor, FontWeight.bold),
        ));

bottomNavBarTextStyle({FontWeight fontWeight = FontWeight.w600}) =>
    TextStyle(fontFamily: primaryFontName, fontWeight: fontWeight);

Padding misScreenPadding({required Widget child, double padding = 24}) =>
    Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );

Container borderContainer(
        {required Widget child,
        double padding = 12,
        double circularRadius = 8.0,
        double? height}) =>
    Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(color: AppColorHelper().borderColor),
        borderRadius: BorderRadius.circular(circularRadius),
      ),
      child: child,
    );

InkWell iconWidget(IconData iconData,
        {double size = 24, Color? color, VoidCallback? onPressed}) =>
    InkWell(
      onTap: onPressed,
      child: Icon(iconData,
          size: size, color: color ?? AppColorHelper().iconColor),
    );

Checkbox checkbox({required bool value, required Function(bool) onChanged}) =>
    Checkbox(
      value: value,
      activeColor: AppColorHelper().primaryColor,
      onChanged: (value) => onChanged(value ?? false),
    );

// Image sortIcon() {
//   String imagePath;
//   imagePath = switch (AppEnvironment.appClient) {
//     AppClient.demo => Assets.icons.atoz.path,
//     AppClient.muziris => Assets.icons.atoz.path,
//     AppClient.seemati => Assets.icons.atozSeemaatti.path,
//     AppClient.kalyan => Assets.icons.atoz.path
//   };
//   return Image.asset(imagePath);
// }

Widget appText(String text,
    {double fontSize = 14.0,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.w300,
    Color color = const Color.fromARGB(255, 0, 0, 0),
    TextAlign textAlign = TextAlign.start,
    TextOverflow? overflow,
    int? maxLines,
    double? height}) {
  return Text(
    text,
    style: GoogleFonts.roboto(
        textStyle: TextStyle(
            decoration: TextDecoration.none,
            fontFamily: "Roboto",
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            height: height)),
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    softWrap: true,
  );
}

RichText superscriptDateWidget({
  required DateTime date,
  Color? textColor,
  double? fontSize = 14,
  FontWeight? fontWeight,
  TextDecoration decoration = TextDecoration.none,
}) {
  String day = date.day.toString();
  String suffix = DateHelper.getDaySuffix(date.day);
  String month = DateHelper.getMonthAbbreviation(date.month);
  TextStyle textStyle = TextStyle(
      fontSize: fontSize ?? 14,
      color: textColor ?? AppColorHelper().textColor,
      fontWeight: fontWeight ?? FontWeight.bold,
      decoration: decoration);
  return RichText(
    text: TextSpan(
      style: textStyle,
      children: [
        TextSpan(
          text: day,
          style: textStyle,
        ),
        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(0.0, -5.0), // Superscript effect
            child: Text(
              suffix,
              style: TextStyle(
                fontSize: fontSize! - 3,
                fontWeight: fontWeight ?? FontWeight.bold,
                color: textColor ?? AppColorHelper().textColor,
              ),
            ),
          ),
        ),
        TextSpan(
          text: " $month",
          style: textStyle,
        ),
      ],
    ),
  );
}

String humanize(String text) {
  final regex = RegExp(r'(?<=[a-z])(?=[A-Z])'); // split before uppercase
  final words = text.split(regex).join(" ").split(" "); // also split on spaces
  return words.map((w) {
    if (w.isEmpty) return w;
    return w[0].toUpperCase() + w.substring(1).toLowerCase();
  }).join(" ");
}

class CircleLoader extends StatefulWidget {
  final List<Color> colors;
  final double minSize;
  final double maxSize;
  final Duration duration;

  const CircleLoader({
    super.key,
    this.colors = const [
      Colors.white,
      Colors.amber,
      Colors.white,
      Colors.amber,
    ],
    this.minSize = 8.0,
    this.maxSize = 20.0,
    this.duration = const Duration(milliseconds: 3000),
  });

  @override
  State<CircleLoader> createState() => _CircleLoaderState();
}

class _CircleLoaderState extends State<CircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _circleScale(int index, double progress) {
    // Each circle gets a phase shift
    final double phaseShift = (index / widget.colors.length) * 2 * math.pi;
    final double value = math.sin(progress * 2 * math.pi - phaseShift);

    // Map sine [-1, 1] into scale range [min, max]
    final double normalized =
        ((value + 1) / 2) * (widget.maxSize - widget.minSize) + widget.minSize;

    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.colors.length, (index) {
            final size = _circleScale(index, _controller.value);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: widget.colors[index],
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

class LoopingProgressBar extends StatefulWidget {
  final double width;
  final double height;
  final Color trackColor;
  final Color progressColor;
  final Duration duration;

  const LoopingProgressBar({
    super.key,
    this.width = 150,
    this.height = 8,
    this.trackColor = Colors.white30,
    this.progressColor = const Color.fromARGB(255, 202, 48, 48),
    this.duration = const Duration(milliseconds: 1500), // Faster speed
  });

  @override
  _LoopingProgressBarState createState() => _LoopingProgressBarState();
}

class _LoopingProgressBarState extends State<LoopingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.width).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _startLoop();
  }

  void _startLoop() {
    _controller.forward().whenComplete(() {
      _controller.reset();
      _startLoop(); // Restart loop faster
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background Track
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.trackColor,
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
          ),
          // Animated Progress Bar
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: _animation.value,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.progressColor,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
