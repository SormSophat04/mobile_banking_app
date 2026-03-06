import 'package:mobile_banking_app/core/config/env_config.dart';
import 'package:mobile_banking_app/core/config/flavor.dart';

class AppConfig {
  static late Flavor flavor;
  static late EnvConfig envConfig;

  static void init(Flavor f) {
    flavor = f;
    switch (f) {
      case Flavor.dev:
        envConfig = const EnvConfig(
          apiBaseUrl: "https://dev-api.example.com",
          appName: "Mobile Banking App Dev",
          enableLog: true,
        );
        break;
      case Flavor.prod:
        envConfig = const EnvConfig(
          apiBaseUrl: "https://prod-api.example.com",
          appName: "Mobile Banking App Prod",
          enableLog: false,
        );
        break;
    }
  }
}
