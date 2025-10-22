import '../env_config.dart';

class UatEnvironment extends EnvironmentConfig {
  UatEnvironment()
      : super(
          // baseApiurl:
          //     'https://postpmobappservice.kalyanjewellers.company/juelisV2gateway/posthirdparty/transactionsummarydata',
          // baseTokenApiurl:
          //     'https://postpmobappservice.kalyanjewellers.company/juelisV2gateway/juelisV2Identity', //live

          baseApiurl:
              'http://202.164.153.62:8409/juelisV2gateway/posthirdparty/transactionsummarydata',
          baseTokenApiurl:
              'http://202.164.153.62:8409/juelisV2gateway/juelisV2Identity',
          title: 'KALYAN UAT',
          enableLogs: true,
          version: 'v1.0.0 -uat',
          enableNetworkImages: true,
          appUpdateDate: '16th September 2025 04:30 PM',
          releaseDate: '16th September 2025 ',
        );
}
