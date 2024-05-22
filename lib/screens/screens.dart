import 'package:drip_vpn/screens/home/home.dart';
import 'package:drip_vpn/screens/purchase/purchase.dart';
import 'package:drip_vpn/screens/setting/setting.dart';
import 'package:drip_vpn/screens/sever/servers.dart';
import 'package:drip_vpn/screens/start/start.dart';
import 'package:go_router/go_router.dart';

const String start = '/start';
const String home = '/home';
const String setting = '/setting';
const String servers = '/servers';
const String purchase = '/purchase';

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
      path: servers,
      builder: (context, state) => const ServersScreen(),
    ),
    GoRoute(
      path: purchase,
      builder: (context, state) => const PurchaseScreen(),
    )
  ],
  initialLocation: start,
);
