import 'package:flutter/material.dart';

import '../../enum.dart';

class AppTheme {
  final String name; // Client name or identifier
  final Color dashBoardContainerBgColor;
  final Color unreadNotification;
  final Color readNotification;
  final Color buttonContainerBgColor;
  final Color loaderColor;
  final Color loaderSecondaryColor;
  final Color toastMsgColor;
  final Color circleAvatarBgColor;
  final Color boxShadowColor;
  final Color pwdFormFieldBorderColor;
  final Color cardTextColor;
  final Color transparentColor;
  final Color primaryColor;
  final Color primaryColorLight;
  final Color primaryColorDark;
  final Color backgroundColor;
  final Color cardColor;
  final Color dialogBackgroundColor;
  final Color canvasColor;
  final Color buttonColor;
  final Color textColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color teritiaryTextColor;
  final Color buttonTextColor;
  final Color disabledTextColor;
  final Color hintColor;
  final Color errorColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color disabledBorderColor;
  final Color errorBorderColor;
  final Color dividerColor;
  final Color iconColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;

  final Color tabbarBgClr;
  final Color tabBarSelectionClr;
  final Color tabBarUnSelectedClr;
  final Color progressbarBgclr;
  final Color progressbarclr;

  final Color iconSelctedClr;
  final Color iconUnSelectedClr;

  final Color lendColor;
  final Color borrowColor;

  final Color lastSynchedWidgetBgColor;
  final Color lastSynchedWidgetTextColor;

  final Color checkBoxColor;
  final Color checkBoxBorderColor;

  final Color clearTextColor;
  final Color togglebgColor;

  final Color cardColor2;
  final Color cardColor3;
  final Color pieColor;
  final Color pieBgColor;

  final Color expenseColor;
  final Color incomeColor;
  final Color transactionColor;
  final Color ledgerColor;

  final Color foodColor;
  final Color salaryColor;
  final Color fuelColor;
  final Color travelColor;
  final Color homeRentColor;
  final Color shoppingColor;
  final Color moviesColor;
  final Color billsColor;
  final Color rechargeColor;
  final Color savingsColor;
  final Color missColor;

  final String fontFamily;
  final String imagePath; // Path to client-specific images

  AppTheme({
    required this.name,
    required this.dashBoardContainerBgColor,
    required this.unreadNotification,
    required this.readNotification,
    required this.buttonContainerBgColor,
    required this.loaderColor,
    required this.loaderSecondaryColor,
    required this.toastMsgColor,
    required this.circleAvatarBgColor,
    required this.boxShadowColor,
    required this.pwdFormFieldBorderColor,
    required this.cardTextColor,
    required this.transparentColor,
    required this.primaryColor,
    required this.primaryColorLight,
    required this.primaryColorDark,
    required this.backgroundColor,
    required this.cardColor,
    required this.dialogBackgroundColor,
    required this.canvasColor,
    required this.buttonColor,
    required this.textColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.teritiaryTextColor,
    required this.disabledTextColor,
    required this.buttonTextColor,
    required this.hintColor,
    required this.errorColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.enabledBorderColor,
    required this.disabledBorderColor,
    required this.errorBorderColor,
    required this.dividerColor,
    required this.iconColor,
    required this.selectedIconColor,
    required this.unselectedIconColor,
    required this.fontFamily,
    required this.imagePath,
    required this.tabbarBgClr,
    required this.tabBarSelectionClr,
    required this.tabBarUnSelectedClr,
    required this.progressbarBgclr,
    required this.progressbarclr,
    required this.iconSelctedClr,
    required this.iconUnSelectedClr,
    required this.lendColor,
    required this.borrowColor,
    required this.lastSynchedWidgetBgColor,
    required this.lastSynchedWidgetTextColor,
    required this.checkBoxColor,
    required this.checkBoxBorderColor,
    required this.clearTextColor,
    required this.togglebgColor,
    required this.cardColor2,
    required this.cardColor3,
    required this.pieColor,
    required this.pieBgColor,
    required this.expenseColor,
    required this.incomeColor,
    required this.transactionColor,
    required this.ledgerColor,
    required this.foodColor,
    required this.salaryColor,
    required this.fuelColor,
    required this.travelColor,
    required this.homeRentColor,
    required this.shoppingColor,
    required this.moviesColor,
    required this.billsColor,
    required this.rechargeColor,
    required this.savingsColor,
    required this.missColor,
  });
}

final Map<AppClient, Map<ThemeModeType, AppTheme>> appThemes = {
  AppClient.muziris: {
    ThemeModeType.light: _demoLightTheme(),
    ThemeModeType.dark: _demoDarkTheme(),
  },
  AppClient.kalyan: {
    ThemeModeType.light: _demoLightTheme(),
    ThemeModeType.dark: _demoDarkTheme(),
  },
};

AppTheme _demoDarkTheme() => AppTheme(
      name: 'Demo',

      cardTextColor: Colors.white,
      readNotification: const Color.fromARGB(255, 255, 254, 254),
      unreadNotification: const Color.fromRGBO(29, 180, 106, 1),
      dashBoardContainerBgColor: const Color(0xFFD9D9EB).withOpacity(.12),
      buttonContainerBgColor: const Color(0xFF464544),
      loaderColor: Colors.white.withOpacity(0.5),
      loaderSecondaryColor: Colors.white.withOpacity(0.5),
      circleAvatarBgColor: const Color.fromARGB(255, 255, 255, 255),
      toastMsgColor: const Color(0xff323030),
      boxShadowColor: Colors.black.withOpacity(.1),
      pwdFormFieldBorderColor: Colors.black54,
      transparentColor: Colors.transparent,
      primaryColor: Color.fromRGBO(3, 188, 145, 1),
      primaryColorLight: Color.fromRGBO(2, 220, 169, 1),
      primaryColorDark: Color.fromRGBO(1, 151, 116, 1),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      cardColor: const Color.fromARGB(255, 33, 33, 33)!,
      dialogBackgroundColor: Colors.grey[800]!,
      canvasColor: Colors.grey[900]!,
      buttonColor: Color.fromRGBO(173, 255, 239, 1),
      textColor: Colors.white,
      primaryTextColor: Colors.white,
      secondaryTextColor: Colors.grey[400]!,
      teritiaryTextColor: Color.fromRGBO(65, 140, 157, 1),
      disabledTextColor: Colors.grey[600]!,
      buttonTextColor: Colors.white,
      hintColor: Colors.grey[500]!,
      errorColor: Colors.redAccent,
      borderColor: const Color.fromRGBO(218, 158, 24, 1),
      focusedBorderColor: Colors.lightBlueAccent,
      enabledBorderColor: Colors.grey[700]!,
      disabledBorderColor: Colors.grey[800]!,
      errorBorderColor: Colors.redAccent,
      dividerColor: Colors.grey[600]!,
      iconColor: Colors.white,
      selectedIconColor: Colors.lightBlue,
      unselectedIconColor: Colors.grey[600]!,

      //navbar
      tabbarBgClr: const Color.fromARGB(255, 224, 224, 224),
      tabBarSelectionClr: Color.fromRGBO(2, 220, 169, 1),
      tabBarUnSelectedClr: const Color.fromARGB(85, 213, 213, 213),

      // icon selection
      iconSelctedClr: const Color.fromARGB(255, 0, 0, 0),
      iconUnSelectedClr: const Color.fromARGB(255, 255, 255, 255),

      //progressbar
      progressbarBgclr: const Color.fromARGB(255, 36, 36, 36),
      progressbarclr: const Color.fromARGB(255, 255, 255, 255),

      //
      lendColor: const Color.fromARGB(255, 108, 249, 209),
      borrowColor: const Color.fromARGB(255, 254, 95, 95),

      //
      lastSynchedWidgetBgColor: const Color.fromRGBO(255, 252, 226, 1),
      lastSynchedWidgetTextColor: const Color.fromRGBO(99, 106, 103, 1),

      // checkbox
      checkBoxColor: Color.fromRGBO(65, 140, 157, 1),
      checkBoxBorderColor: Color.fromRGBO(65, 140, 157, 1),

      clearTextColor: const Color.fromARGB(255, 79, 174, 234),

      togglebgColor: const Color.fromRGBO(218, 165, 32, 1),

      cardColor2: const Color.fromARGB(255, 236, 230, 252),
      cardColor3: const Color.fromARGB(255, 192, 227, 97),
      pieColor: const Color.fromRGBO(136, 124, 168, 1),
      pieBgColor: const Color.fromARGB(255, 181, 181, 181),

      // expenses
      expenseColor: const Color.fromARGB(255, 254, 95, 95),
      incomeColor: const Color.fromARGB(255, 60, 225, 140),

      // icons
      transactionColor: const Color.fromARGB(255, 77, 39, 79),
      ledgerColor: const Color.fromARGB(255, 227, 125, 66),

      // categories
      foodColor: const Color.fromARGB(255, 182, 250, 93),
      salaryColor: const Color.fromARGB(255, 92, 236, 255),
      fuelColor: const Color.fromARGB(255, 239, 255, 96),
      travelColor: const Color.fromARGB(255, 135, 81, 249),
      homeRentColor: const Color.fromARGB(255, 255, 80, 139),
      shoppingColor: const Color.fromARGB(255, 254, 160, 51),
      moviesColor: const Color.fromARGB(255, 86, 111, 255),
      billsColor: const Color(0xFFFF7043),
      rechargeColor: const Color.fromARGB(255, 105, 42, 54),
      savingsColor: const Color.fromARGB(255, 156, 255, 125),
      missColor: const Color.fromARGB(255, 125, 188, 255),

      fontFamily: 'Roboto',
      imagePath: 'assets/images/demo.png',
    );
AppTheme _demoLightTheme() => AppTheme(
      name: 'Demo',

      cardTextColor: Colors.black,

      dashBoardContainerBgColor: const Color(0xff767680).withOpacity(.12),
      readNotification: const Color.fromARGB(255, 255, 254, 254),
      unreadNotification: const Color.fromARGB(255, 249, 30, 30),
      buttonContainerBgColor: const Color(0xffF3F1EE),
      loaderColor: const Color.fromARGB(255, 255, 255, 255),
      loaderSecondaryColor: const Color.fromARGB(255, 255, 255, 255),
      circleAvatarBgColor: const Color.fromARGB(255, 255, 255, 255),
      toastMsgColor: const Color.fromARGB(255, 50, 50, 48),
      pwdFormFieldBorderColor: const Color.fromRGBO(65, 140, 157, 1),
      boxShadowColor: Colors.black.withOpacity(.1),
      transparentColor: Colors.transparent,
      primaryColor: Color.fromRGBO(3, 188, 145, 1),
      primaryColorLight: Color.fromRGBO(2, 220, 169, 1),
      primaryColorDark: Color.fromRGBO(1, 151, 116, 1),
      backgroundColor: const Color.fromARGB(255, 241, 240, 240),
      cardColor: const Color.fromARGB(255, 255, 255, 255),
      dialogBackgroundColor: Colors.white,
      canvasColor: const Color.fromARGB(255, 245, 243, 248)!,
      buttonColor: Color.fromRGBO(173, 255, 239, 1),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      primaryTextColor: const Color.fromARGB(255, 0, 0, 0),
      secondaryTextColor: const Color.fromARGB(255, 149, 149, 149),
      teritiaryTextColor: Color.fromRGBO(65, 140, 157, 1),
      disabledTextColor: const Color.fromARGB(255, 224, 223, 223)!,
      buttonTextColor: Colors.white,
      hintColor: const Color.fromARGB(255, 77, 76, 76)!,
      errorColor: const Color.fromRGBO(217, 75, 77, 1),
      borderColor: const Color.fromARGB(255, 25, 25, 25),
      focusedBorderColor: const Color.fromRGBO(65, 140, 157, 1),
      enabledBorderColor: const Color.fromRGBO(65, 140, 157, 1),
      disabledBorderColor: const Color.fromARGB(255, 20, 44, 49),
      errorBorderColor: Colors.redAccent,
      dividerColor: Colors.grey,
      iconColor: const Color.fromRGBO(81, 55, 136, 1),
      selectedIconColor: const Color.fromRGBO(180, 29, 141, 1)!,
      unselectedIconColor: Colors.grey,

      //tabbar
      tabBarSelectionClr: Color.fromRGBO(105, 249, 215, 1),
      tabbarBgClr: const Color.fromARGB(255, 40, 40, 40),
      tabBarUnSelectedClr: const Color.fromARGB(84, 174, 174, 174),

      // icon selection
      iconSelctedClr: const Color.fromARGB(255, 242, 176, 35),
      iconUnSelectedClr: const Color.fromARGB(255, 240, 240, 240),

      //progressbar
      progressbarBgclr: const Color.fromARGB(48, 193, 192, 192),
      progressbarclr: const Color.fromARGB(255, 255, 255, 255),

      //
      lendColor: const Color.fromARGB(255, 108, 249, 209),
      borrowColor: const Color.fromARGB(255, 254, 95, 95),

      //
      lastSynchedWidgetBgColor: const Color.fromRGBO(255, 252, 226, 1),
      lastSynchedWidgetTextColor: const Color.fromRGBO(99, 106, 103, 1),

      // checkbox
      checkBoxColor: Color.fromRGBO(65, 140, 157, 1),
      checkBoxBorderColor: Color.fromRGBO(65, 140, 157, 1),

      clearTextColor: const Color.fromARGB(255, 79, 174, 234),

      togglebgColor: const Color.fromRGBO(218, 165, 32, 1),

      cardColor2: const Color.fromARGB(255, 3, 173, 179),
      cardColor3: const Color.fromARGB(255, 192, 227, 97),
      pieColor: const Color.fromRGBO(136, 124, 168, 1),
      pieBgColor: const Color.fromARGB(255, 181, 181, 181),

      // expenses
      expenseColor: const Color.fromARGB(255, 254, 95, 95),
      incomeColor: const Color.fromARGB(255, 60, 225, 140),

      // icons
      transactionColor: const Color.fromARGB(255, 77, 39, 79),
      ledgerColor: const Color.fromARGB(255, 227, 125, 66),

// categories
      foodColor: const Color.fromARGB(255, 182, 250, 93),
      salaryColor: const Color.fromARGB(255, 92, 236, 255),
      fuelColor: const Color.fromARGB(255, 239, 255, 96),
      travelColor: const Color.fromARGB(255, 135, 81, 249),
      homeRentColor: const Color.fromARGB(255, 255, 80, 139),
      shoppingColor: const Color.fromARGB(255, 254, 160, 51),
      moviesColor: const Color.fromARGB(255, 86, 111, 255),
      billsColor: const Color(0xFFFF7043),
      rechargeColor: const Color.fromARGB(255, 105, 42, 54),
      savingsColor: const Color.fromARGB(255, 156, 255, 125),
      missColor: const Color.fromARGB(255, 125, 188, 255),

      fontFamily: 'Roboto',
      imagePath: 'assets/images/demo.png',
    );
