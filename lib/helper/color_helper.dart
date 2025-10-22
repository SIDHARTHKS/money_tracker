import 'dart:ui';

import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';

class AppColorHelper {
  AppTheme get _currentTheme => Get.find<AppThemeService>().currentTheme;

  Color get primaryColor => _currentTheme.primaryColor;
  Color get primaryColorLight => _currentTheme.primaryColorLight;
  Color get primaryColorDark => _currentTheme.primaryColorDark;
  Color get backgroundColor => _currentTheme.backgroundColor;
  Color get cardColor => _currentTheme.cardColor;
  Color get dialogBackgroundColor => _currentTheme.dialogBackgroundColor;
  Color get canvasColor => _currentTheme.canvasColor;
  Color get buttonColor => _currentTheme.buttonColor;
  //
  Color get textColor => _currentTheme.textColor;
  Color get primaryTextColor => _currentTheme.primaryTextColor;
  Color get secondaryTextColor => _currentTheme.secondaryTextColor;
  Color get teritiaryTextColor => _currentTheme.teritiaryTextColor;
  Color get buttonTextColor => _currentTheme.buttonTextColor;
  Color get disabledTextColor => _currentTheme.disabledTextColor;
  Color get hintColor => _currentTheme.hintColor;
  Color get errorColor => _currentTheme.errorColor;
  //
  Color get borderColor => _currentTheme.borderColor;
  Color get focusedBorderColor => _currentTheme.focusedBorderColor;
  Color get enabledBorderColor => _currentTheme.enabledBorderColor;
  Color get disabledBorderColor => _currentTheme.disabledBorderColor;
  Color get errorBorderColor => _currentTheme.errorBorderColor;
  //
  Color get dividerColor => _currentTheme.dividerColor;
  Color get iconColor => _currentTheme.iconColor;
  Color get selectedIconColor => _currentTheme.selectedIconColor;
  Color get unselectedIconColor => _currentTheme.unselectedIconColor;
  Color get cardTextColor => _currentTheme.cardTextColor;
  Color get transparentColor => _currentTheme.transparentColor;
  Color get pwdFormFieldBorderColor => _currentTheme.pwdFormFieldBorderColor;
  Color get boxShadowColor => _currentTheme.boxShadowColor;
  Color get circleAvatarBgColor => _currentTheme.circleAvatarBgColor;
  Color get toastMsgColor => _currentTheme.toastMsgColor;
  Color get loaderColor => _currentTheme.loaderColor;
  Color get loaderSecondaryColor => _currentTheme.loaderSecondaryColor;
  Color get buttonContainerBgColor => _currentTheme.buttonContainerBgColor;
  Color get readNotification => _currentTheme.readNotification;
  Color get unreadNotification => _currentTheme.unreadNotification;
  Color get dashBoardContainerBgColor =>
      _currentTheme.dashBoardContainerBgColor;

  Color get tabbarBgClr => _currentTheme.tabbarBgClr;
  Color get tabBarSelectionClr => _currentTheme.tabBarSelectionClr;
  Color get tabBarUnSelectedClr => _currentTheme.tabBarUnSelectedClr;

  Color get progressbarBgclr => _currentTheme.progressbarBgclr;
  Color get progressbarclr => _currentTheme.progressbarclr;

  Color get iconSelctedClr => _currentTheme.iconSelctedClr;
  Color get iconUnSelectedClr => _currentTheme.iconUnSelectedClr;

  Color get lendColor => _currentTheme.lendColor;
  Color get borrowColor => _currentTheme.borrowColor;

  Color get checkBoxColor => _currentTheme.checkBoxColor;
  Color get checkBoxBorderColor => _currentTheme.checkBoxBorderColor;

  Color get lastSynchedWidgetBgColor => _currentTheme.lastSynchedWidgetBgColor;
  Color get lastSynchedWidgetTextColor =>
      _currentTheme.lastSynchedWidgetTextColor;

  Color get clearTextColor => _currentTheme.clearTextColor;

  Color get togglebgColor => _currentTheme.togglebgColor;

  Color get expenseColor => _currentTheme.expenseColor;
  Color get incomeColor => _currentTheme.incomeColor;

  Color get cardColor2 => _currentTheme.cardColor2;
  Color get pieColor => _currentTheme.pieColor;
  Color get pieBgColor => _currentTheme.pieBgColor;

  Color get transactionColor => _currentTheme.transactionColor;
  Color get ledgerColor => _currentTheme.ledgerColor;

  Color get foodColor => _currentTheme.foodColor;
  Color get salaryColor => _currentTheme.salaryColor;
  Color get fuelColor => _currentTheme.fuelColor;
  Color get travelColor => _currentTheme.travelColor;
  Color get homeRentColor => _currentTheme.homeRentColor;
  Color get shoppingColor => _currentTheme.shoppingColor;
  Color get moviesColor => _currentTheme.moviesColor;
  Color get billsColor => _currentTheme.billsColor;
  Color get rechargeColor => _currentTheme.rechargeColor;
  Color get savingsColor => _currentTheme.savingsColor;
}
