import 'package:mobile_banking_app/common.dart';
import 'package:mobile_banking_app/core/config/app_config.dart';
import 'package:mobile_banking_app/core/config/flavor.dart';
void main() {
  AppConfig.init(Flavor.dev);
  mainFlavor();
}
