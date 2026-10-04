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
      baseUrl: 'https://h2oexpress.in/waterdelivery/api/apps/',
      baseUrl1: '',
      keyClockUrl: '',
      enableLogger: true,
    ),
    AppFlavor.stage: Env(
      baseUrl: 'https://h2oexpress.in/waterdelivery/api/apps/',
      baseUrl1: '',
      keyClockUrl: '',

      enableLogger: true,
    ),
    AppFlavor.prod: Env(
      baseUrl: 'https://h2oexpress.in/waterdelivery/api/apps/',
      baseUrl1: '',
      keyClockUrl: '',

      enableLogger: false,
    ),
  }[flavor]!;
}
