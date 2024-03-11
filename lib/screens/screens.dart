import 'package:go_router/go_router.dart';
import 'package:sweet_vpn/screens/execute/execute.dart';
import 'package:sweet_vpn/screens/home/home.dart';
import 'package:sweet_vpn/screens/result/result.dart';
import 'package:sweet_vpn/screens/setting/setting.dart';
import 'package:sweet_vpn/screens/start/start.dart';

const String start = '/start';
const String home = '/home';
const String setting = '/setting';
const String executing = '/executing';
const String result = '/result';

final screens = GoRouter(
  routes: [
    GoRoute(
      path: start,
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: setting,
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: executing,
      builder: (context, state) => const ExecuteScreen(),
    ),
    GoRoute(
      path: result,
      builder: (context, state) => const ResultScreen(),
    )
  ],
  initialLocation: start,
);
