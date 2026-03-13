import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:safe_device/safe_device.dart';

class DeviceSecurityService {
  static const Duration _cacheDuration = Duration(minutes: 5);
  static DateTime? _lastCheckedAt;
  static bool? _lastResult;
  static Future<bool>? _inflight;

  Future<bool> checkDeviceSecurity() async {
    final now = DateTime.now();
    if (_lastResult != null &&
        _lastCheckedAt != null &&
        now.difference(_lastCheckedAt!) < _cacheDuration) {
      return _lastResult!;
    }

    if (_inflight != null) {
      return _inflight!;
    }

    _inflight = _checkAll().then((result) {
      _lastResult = result;
      _lastCheckedAt = DateTime.now();
      return result;
    }).whenComplete(() {
      _inflight = null;
    });

    return _inflight!;
  }

  Future<bool> _checkAll() async {
    final results = await Future.wait<bool>([
      _checkIfRooted(),
      _checkIfEmulator(),
      _checkDeveloperMode(),
      _checkDebugger(),
    ]);

    final isRooted = results[0];
    final isEmulator = results[1];
    final isDeveloperMode = results[2];
    final isDebuggerActive = results[3];

    return !isRooted && !isEmulator && !isDeveloperMode && !isDebuggerActive;
  }

  Future<bool> _checkIfRooted() async {
    return JailbreakRootDetection.instance.isJailBroken;
  }

  Future<bool> _checkIfEmulator() async {
    final isRealDevice = await SafeDevice.isRealDevice;
    return !isRealDevice;
  }

  Future<bool> _checkDeveloperMode() async {
    return await SafeDevice.isDevelopmentModeEnable;
  }

  Future<bool> _checkDebugger() async {
    return JailbreakRootDetection.instance.isDebugged;
  }
}
