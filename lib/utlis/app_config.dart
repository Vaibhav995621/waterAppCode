enum AppFlavor { dev, stage, prod }

class Env {
  final String baseUrl;
  final String baseUrl1;
  final String keyClockUrl;

  final bool enableLogger;

  const Env({
    required this.baseUrl,
    required this.baseUrl1,
    required this.keyClockUrl,
    required this.enableLogger,

  });
}

class AppConfig {
  // 👇 change only this
  static const flavor = AppFlavor.dev;

  static final config = {
    AppFlavor.dev: Env(
      baseUrl: 'https://sbgodeal.com/waterdelivery/api/apps/',
      baseUrl1: 'https://zourney-api-dev.kellton.net/api/',
      keyClockUrl: '',
      enableLogger: true,
    ),
    AppFlavor.stage: Env(
      baseUrl: 'https://stage-api.zourney.app',
      baseUrl1: 'https://zourney-api-dev.kellton.net/api/',
      keyClockUrl: '',

      enableLogger: true,
    ),
    AppFlavor.prod: Env(
      baseUrl: 'https://api.zourney.app',
      baseUrl1: 'https://zourney-api-dev.kellton.net/api/',
      keyClockUrl: '',

      enableLogger: false,
    ),
  }[flavor]!;
}
