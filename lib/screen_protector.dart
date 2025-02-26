import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:screen_protector/extension/color_extension.dart';

class ScreenProtector {
  static const MethodChannel _channel = MethodChannel('screen_protector');

  static void Function()? _onScreenshotListener;
  static void Function(bool)? _onScreenRecordListener;

  /// Add callback actions when screenshot or screen record events received,
  /// Supported for iOS only, donothing when run on Android.
  static void addListener(
    void Function()? screenshotListener,
    void Function(bool)? screenRecordListener,
  ) async {
    _onScreenshotListener = screenshotListener;
    _onScreenRecordListener = screenRecordListener;

    _channel.setMethodCallHandler(_methodCallHandler);
    await _channel.invokeMethod('addListener');
  }

  /// Remove listeners
  static void _removeListener() {
    _onScreenshotListener = null;
    _onScreenRecordListener = null;
  }

  /// Remove observers
  /// Supported for iOS only, donothing when run on Android.
  static void removeListener() async {
    _removeListener();
    await _channel.invokeMethod('removeListener');
  }

  static Future<dynamic> _methodCallHandler(MethodCall call) async {
    if (call.method == 'onScreenshot') {
      if (null != _onScreenshotListener) {
        _onScreenshotListener!();
      }
    } else if (call.method == 'onScreenRecord') {
      dynamic isCaptured = call.arguments;
      if (null != _onScreenRecordListener &&
          isCaptured != null &&
          isCaptured is bool) {
        _onScreenRecordListener!(isCaptured);
      }
    }
  }

  // /// Supported for Anddroid only, donothing when run on iOS.
  // static Future<void> protectDataLeakageOn() async {
  //   return await _channel.invokeMethod('protectDataLeakageOn');
  // }

  // /// Supported for Anddroid only, donothing when run on iOS.
  // static Future<void> protectDataLeakageOff() async {
  //   return await _channel.invokeMethod('protectDataLeakageOff');
  // }

  /// Supported for iOS only, donothing when run on Android.
  static Future<void> protectDataLeakageWithBlur() async {
    return await _channel.invokeMethod('protectDataLeakageWithBlur');
  }

  /// Supported for iOS only, donothing when run on Android.
  static Future<void> protectDataLeakageWithImage(String imageName) async {
    return await _channel.invokeMethod('protectDataLeakageWithImage', {
      'name': imageName,
    });
  }

  /// Supported for iOS only, donothing when run on Android.
  static Future<void> protectDataLeakageWithColor(Color color) async {
    return await _channel.invokeMethod('protectDataLeakageWithColor', {
      'hexColor': color.toHex(),
    });
  }

  /// Supported for Anddroid and iOS.
  static Future<void> preventScreenshotOn() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

    } else if (Platform.isIOS) {
      return await _channel.invokeMethod('preventScreenshotOn');
    }
  }

  /// Supported for Anddroid and iOS.
  static Future<void> preventScreenshotOff() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isIOS) {
      return await _channel.invokeMethod('preventScreenshotOff');
    }
  }
}
