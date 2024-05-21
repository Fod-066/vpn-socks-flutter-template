import 'package:drip_vpn/screens/execute/execute.dart';
import 'package:drip_vpn/screens/home/home.dart';
import 'package:drip_vpn/screens/luck/luck.dart';
import 'package:drip_vpn/screens/result/result.dart';
import 'package:drip_vpn/screens/setting/setting.dart';
import 'package:drip_vpn/screens/sever/servers.dart';
import 'package:drip_vpn/screens/start/start.dart';
import 'package:go_router/go_router.dart';

const String start = '/start';
const String home = '/home';
const String setting = '/setting';
const String executing = '/executing';
const String result = '/result';
const String luck = '/luck';
const String servers = '/servers';

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
    ),
    GoRoute(
      path: luck,
      builder: (context, state) => const LuckScreen(),
    ),
    GoRoute(
      path: servers,
      builder: (context, state) => const ServersScreen(),
    )
  ],
  initialLocation: start,
);
