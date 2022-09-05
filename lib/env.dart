class Environment {
  Environment._internal();
  static final _singleton = Environment._internal();
  factory Environment() => _singleton;

  FlavorConfig _config = FlavorConfig.dev;
  init(FlavorConfig flavor) => _config = flavor;

  FlavorConfig get config => _config;
  bool get isDev => _config == FlavorConfig.dev;
}

// TODO: Specify proper params here
enum FlavorConfig {
  prod(
    backendUrl: 'https://astralnote-backend-vs4jdv4dxa-lz.a.run.app',
    dataSyncInerval: 60,
    feedbackEmail: 'matvei.tikka@gmail.com',
  ),
  dev(
    backendUrl: 'https://astralnote-backend-vs4jdv4dxa-lz.a.run.app',
    dataSyncInerval: 600,
    feedbackEmail: 'matvei.tikka@gmail.com',
  );

  const FlavorConfig({
    required this.feedbackEmail,
    required this.backendUrl,
    required this.dataSyncInerval,
  });
  final String backendUrl, feedbackEmail;
  final int dataSyncInerval;
}
