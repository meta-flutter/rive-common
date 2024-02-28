import 'package:rive_common/platform.dart';

Platform makePlatform() => PlatformWeb();

class PlatformWeb extends Platform {
  @override
  bool get isTesting => false;
}
