import '../env_config.dart';

class DevEnvironment extends EnvironmentConfig {
  DevEnvironment()
      : super(
          baseApiurl:
              'http://202.164.153.62:8409/juelisV2gateway/posthirdparty/transactionsummarydata',
          baseTokenApiurl:
              'http://202.164.153.62:8409/juelisV2gateway/juelisV2Identity',
          title: 'KALYAN Dev',
          enableLogs: true,
          version: 'v1.0.0 -dev',
          enableNetworkImages: true,
          appUpdateDate: '9th September 2025 04:30 PM',
          releaseDate: '9th September 2025',
        );
}
