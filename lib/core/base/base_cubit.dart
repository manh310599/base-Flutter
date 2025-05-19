import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project2/core/base/base_state.dart';

/// Base Cubit class for all Cubits in the application.
/// Provides common functionality for state management.
abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(const BaseState());

  /// Emits a loading state.
  void emitLoading() {
    emit(state.asLoading());
  }

  /// Emits an error state with the given error message.
  void emitError(String errorMessage) {
    emit(state.asError(errorMessage));
  }

  /// Emits a success state with the given data.
  void emitSuccess(T data) {
    emit(state.asSuccess(data));
  }

  /// Executes a function and handles loading, success, and error states.
  ///
  /// [action] is the function to execute.
  /// [onSuccess] is called when the action completes successfully.
  /// [onError] is called when the action throws an error.
  Future<void> executeWithLoading<R>({
    required Future<R> Function() action,
    void Function(R result)? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      emitLoading();
      final result = await action();
      onSuccess?.call(result);
    } catch (e) {
      final errorMessage = e.toString();
      emitError(errorMessage);
      onError?.call(errorMessage);
    }
  }
}
