import '../env_config.dart';

class ProdEnvironment extends EnvironmentConfig {
  ProdEnvironment()
      : super(
          baseApiurl:
              'https://postpmobappservice.kalyanjewellers.company/juelisV2gateway/posthirdparty/transactionsummarydata',
          baseTokenApiurl:
              'https://postpmobappservice.kalyanjewellers.company/juelisV2gateway/juelisV2Identity',
          title: 'KALYAN',
          enableLogs: false,
          version: 'v1.0.0',
          enableNetworkImages: true,
          appUpdateDate: '19th September 2025 12:50 AM',
          releaseDate: '19th September 2025',
        );
}
