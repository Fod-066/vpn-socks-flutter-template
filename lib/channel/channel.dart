import 'package:flutter/services.dart';

const nativeMethod = MethodChannel('drip.vpn.native.method');
const vpnStatusEventChannel = EventChannel('drip.vpn.status.channel');
const profileEventChannel = EventChannel('drip.vpn.profile');
const n2fEventChannel = EventChannel('drip.n2f.event.channel');
