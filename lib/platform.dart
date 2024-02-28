import 'src/platform_native.dart'
    if (dart.library.html) 'src/platform_web.dart';

abstract class Platform {
  bool get isTesting;
  static final Platform instance = makePlatform();
}
