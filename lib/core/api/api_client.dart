import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:path_provider/path_provider.dart';

import '../../app/di/injection.dart';
import '../api/interceptors/auth_interceptor.dart';
import '../api/interceptors/logging_interceptor.dart';
import '../api/interceptors/ssl_pinning_interceptor.dart';
import '../../app/config/app_config.dart';
import '../storage/secure_storage.dart';

part 'api_client.g.dart';

/// Base API client using Retrofit and Dio
@singleton
class ApiClient {
  final Dio _dio;
  final AppConfig _appConfig;

  ApiClient(this._appConfig) : _dio = Dio() {
    _configureDio();
  }

  Future<void> _configureDio() async {
    // Base configuration
    _dio.options = BaseOptions(
      baseUrl: _appConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Setup cache
    final cacheDir = await getTemporaryDirectory();
    final cacheStore = HiveCacheStore(
      '${cacheDir.path}/dio_cache',
      encryptionCipher: HiveAesCipher([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]),
    );

    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.refreshForceCache,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 1),
      priority: CachePriority.normal,
    );

    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(getIt<SecureStorage>()),
      LoggingInterceptor(),
      SSLPinningInterceptor(),
      DioCacheInterceptor(options: cacheOptions),
    ]);
  }

  Dio get dio => _dio;
}

/// Example of a Retrofit API service
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST('/auth/login')
  Future<dynamic> login(@Body() Map<String, dynamic> loginData);

  @POST('/auth/refresh-token')
  Future<dynamic> refreshToken(@Body() Map<String, dynamic> refreshData);

  @POST('/auth/logout')
  Future<void> logout();
}
