import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart' show MethodChannel;
import 'package:meta/meta.dart';
import 'package:rive_common/platform.dart' as rive;

const _platform = MethodChannel('rive');

// ignore: avoid_classes_with_only_static_members
@internal
abstract class RiveDynamicLibraryHelper {
  static final DynamicLibrary nativeLib = open();

  static DynamicLibrary open() {
    if (rive.Platform.instance.isTesting) {
      var paths = [
        '',
        '../../packages/rive_common/',
      ];
      if (Platform.isMacOS) {
        for (final path in paths) {
          try {
            return DynamicLibrary.open(
              '${path}shared_lib/build/bin/debug/librive_text.dylib',
            );

            // ignore: avoid_catching_errors
          } on ArgumentError catch (_) {}
        }
      } else if (Platform.isLinux) {
        for (final path in paths) {
          try {
            return DynamicLibrary.open(
              '${path}shared_lib/build/bin/debug/librive_text.so',
            );
            // ignore: avoid_catching_errors
          } on ArgumentError catch (_) {}
        }
      }
    }

    if (Platform.isAndroid) {
      return _openAndroidDynamicLibraryWithFallback();
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('rive_common_plugin.dll');
    }
    return DynamicLibrary.process();
  }

  static DynamicLibrary _openAndroidDynamicLibraryWithFallback() {
    try {
      return DynamicLibrary.open('librive_text.so');
      // ignore: avoid_catching_errors
    } on ArgumentError {
      // On some (especially old) Android devices, we somehow can't dlopen
      // libraries shipped with the apk. We need to find the full path of the
      // library (/data/data/<id>/lib/librive_text.so) and open that one.
      // For details, see https://github.com/simolus3/sqlite3.dart/issues/29
      final appIdAsBytes = File('/proc/self/cmdline').readAsBytesSync();

      // app id ends with the first \0 character in here.
      final endOfAppId = max(appIdAsBytes.indexOf(0), 0);
      final appId = String.fromCharCodes(appIdAsBytes.sublist(0, endOfAppId));
      return DynamicLibrary.open('/data/data/$appId/lib/librive_text.so');
    }
  }
}

/// An experimental feature that may change or be removed in future releases.
///
/// Workaround to open Rive on old Android versions.
///
/// On old Android versions, this method can help if you're having issues
/// opening Rive (e.g. if you're seeing crashes about `librive_text.so` not
/// being available). To be safe, call this method before using apis from
/// `package:rive`.
@experimental
Future<void> applyWorkaroundToRiveOnOldAndroidVersions() async {
  if (!Platform.isAndroid) return;
  try {
    DynamicLibrary.open('librive_text.so');
    // ignore: avoid_catching_errors
  } on ArgumentError {
    // Ok, the regular approach failed. Try to open rive_text in Kotlin, which
    // seems to fix the problem.
    await _platform.invokeMethod('loadRiveLibrary');

    // Try again. If it still fails we're out of luck.
    DynamicLibrary.open('librive_text.so');
  }
}
