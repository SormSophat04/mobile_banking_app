enum Flavor { dev, prod }

class FlavorConfig {
  static Flavor appFlavor = Flavor.dev;

  static bool get isDev => appFlavor == Flavor.dev;
  static bool get isProd => appFlavor == Flavor.prod;
}
