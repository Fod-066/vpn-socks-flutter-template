
import 'package:flutter/services.dart';

const nativeMethod = MethodChannel('access.vpn.native.method');
const vpnStatusEventChannel = EventChannel('access.vpn.status.channel');
const profileEventChannel = EventChannel('access.vpn.profile');