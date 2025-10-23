import 'package:get/get.dart';
import 'package:tracker/binding/chart_binding.dart';
import 'package:tracker/binding/home_binding.dart';
import 'package:tracker/binding/landing_binding.dart';
import 'package:tracker/binding/savings_binding.dart';
import 'package:tracker/binding/transaction_binding.dart';
import 'package:tracker/view/chart/chart_screen.dart';
import 'package:tracker/view/home/home_screen.dart';
import 'package:tracker/view/landing/landing_screen.dart';
import 'package:tracker/view/ledger/ledger_screen.dart';
import 'package:tracker/view/savings/savings_screen.dart';
import 'package:tracker/view/transactions/view_all_screen.dart';
import '../binding/splash_binding.dart';
import '../view/splash/splash_screen.dart';

const loginPageRoute = '/login';
const splashPageRoute = '/splash';
const landingPageRoute = '/landing';
const homePageRoute = '/home';
const settingsPageRoute = '/settings';
const ledgerPageRoute = '/ledger';
const viewAllPageRoute = '/viewAll';
const savingsPageRoute = '/savings';
const cahrtPageRoute = '/chart';

final routes = [
  GetPage(
      name: splashPageRoute,
      page: () => const SplashScreen(),
      binding: const SplashBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: landingPageRoute,
      page: () => const LandingScreen(),
      binding: const LandingBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: homePageRoute,
      page: () => const HomeScreen(),
      binding: const HomeBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: ledgerPageRoute,
      page: () => const LedgerScreen(),
      binding: const HomeBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: viewAllPageRoute,
      page: () => const ViewAllScreen(),
      binding: const TransactionBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: savingsPageRoute,
      page: () => const SavingsScreen(),
      binding: const SavingsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
  GetPage(
      name: cahrtPageRoute,
      page: () => const ChartScreen(),
      binding: const ChartBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200)),
];
