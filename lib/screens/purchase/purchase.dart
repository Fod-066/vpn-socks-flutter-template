import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/config/color_const.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PurchaseScreen extends StatefulHookConsumerWidget {
  const PurchaseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends ConsumerState<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBack(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 24,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff484855),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Text('Perminum', style: peaceSans),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(Assets.assetsImgsLogo, width: 68, height: 68),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Drip Vpn Perminum',
                        style: peaceSans.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.military_tech, color: Color(0xffffee5b))
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'You can enjoy:',
                    style: peaceSans.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Use All Locations',
                            style: peaceSans.copyWith(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            'Unlock all locations and enjoy unlimited online freedom',
                            style: peaceSans.copyWith(color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '100% Ad-Free experience',
                            style: peaceSans.copyWith(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            'Focus on your online experience without annoying ads',
                            style: peaceSans.copyWith(color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text('Price :', style: peaceSans.copyWith(fontSize: 12)),
                  const SizedBox(height: 8),
                  const Text(
                    '\$3.99/Month',
                    style: TextStyle(color: Color(0xffffee5b), fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 36),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.78,
                        height: 48,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(connectColor),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Subscribe now',
                            style: peaceSans.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: GestureDetector(
                          onTap: () {},
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Cancel anytime ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: 'in Google Play Store App > Profile > Subscriptions',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: const Text('Terms of subscription'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('''
By completing your purchase, you expressly agree with the following terms:

• Payment will be charged to Google Payments account at confirmation of purchase.
• Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.
• Account will be charged for the identified cost of the renewal within 24-hours prior to the end of the current period.
• Subscriptions may be managed by the user and auto-renewal may be turned off by going to Subscriptions menu in Google Play
                        '''),
                              ElevatedButton(
                                onPressed: () => context.pop(),
                                child: const Text('Ok'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Terms of subscription',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
