// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i5;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i7;
import 'package:local_auth/local_auth.dart' as _i8;

import '../../core/api/api_client.dart' as _i9;
import '../../core/api/interceptors/auth_interceptor.dart' as _i14;
import '../../core/network/connectivity_service.dart' as _i11;
import '../../core/security/biometrics_service.dart' as _i10;
import '../../core/security/encryption_service.dart' as _i12;
import '../../core/storage/secure_storage.dart' as _i13;
import '../config/app_config.dart' as _i3;
import '../config/environment.dart' as _i4;
import 'injection.dart' as _i15;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.singleton<_i3.AppConfig>(() => _i3.AppConfig(
          environment: gh<_i4.AppEnvironment>(),
          apiBaseUrl: gh<String>(),
          appName: gh<String>(),
          enableLogging: gh<bool>(),
          enableCrashlytics: gh<bool>(),
          enablePerformanceMonitoring: gh<bool>(),
          sessionTimeoutMinutes: gh<int>(),
          enableBiometrics: gh<bool>(),
          enableSSLPinning: gh<bool>(),
          maxOfflineCacheDays: gh<int>(),
        ));
    gh.singleton<_i5.Connectivity>(() => appModule.connectivity);
    gh.singleton<_i6.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.singleton<_i7.InternetConnectionChecker>(
        () => appModule.internetConnectionChecker);
    gh.singleton<_i8.LocalAuthentication>(() => appModule.localAuthentication);
    gh.singleton<_i9.ApiClient>(() => _i9.ApiClient(gh<_i3.AppConfig>()));
    gh.singleton<_i10.BiometricsService>(
        () => _i10.BiometricsService(gh<_i8.LocalAuthentication>()));
    gh.singleton<_i11.ConnectivityService>(() => _i11.ConnectivityService(
          gh<_i5.Connectivity>(),
          gh<_i7.InternetConnectionChecker>(),
        ));
    gh.singleton<_i12.EncryptionService>(
        () => _i12.EncryptionService(gh<_i6.FlutterSecureStorage>()));
    gh.singleton<_i13.SecureStorage>(() => _i13.SecureStorage(
          gh<_i6.FlutterSecureStorage>(),
          gh<_i12.EncryptionService>(),
        ));
    gh.factory<_i14.AuthInterceptor>(
        () => _i14.AuthInterceptor(gh<_i13.SecureStorage>()));
    return this;
  }
}

class _$AppModule extends _i15.AppModule {}
