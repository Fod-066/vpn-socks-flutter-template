
import 'package:flutter/services.dart';

const nativeMethod = MethodChannel('sweet.vpn.native.method');
const vpnStatusEventChannel = EventChannel('sweet.vpn.status.channel');
const profileEventChannel = EventChannel('sweet.vpn.profile');