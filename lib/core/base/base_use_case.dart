import 'package:base_project2/core/api/api_result.dart';

/// Base use case class for all use cases in the application.
/// 
/// [P] is the type of the parameters.
/// [R] is the type of the result.
abstract class BaseUseCase<P, R> {
  /// Executes the use case with the given parameters.
  Future<ApiResult<R>> execute(P params);

  /// Calls the use case with the given parameters.
  Future<ApiResult<R>> call(P params) => execute(params);
}

/// Base use case class for use cases that don't require parameters.
abstract class BaseUseCaseNoParams<R> {
  /// Executes the use case without parameters.
  Future<ApiResult<R>> execute();

  /// Calls the use case without parameters.
  Future<ApiResult<R>> call() => execute();
}

/// Base use case class for use cases that don't return a result.
abstract class BaseUseCaseNoResult<P> {
  /// Executes the use case with the given parameters.
  Future<void> execute(P params);

  /// Calls the use case with the given parameters.
  Future<void> call(P params) => execute(params);
}

/// Base use case class for use cases that don't require parameters and don't return a result.
abstract class BaseUseCaseNoParamsNoResult {
  /// Executes the use case without parameters.
  Future<void> execute();

  /// Calls the use case without parameters.
  Future<void> call() => execute();
}
