import 'package:flutter/foundation.dart';
import 'package:structure_flutter/data/source/remote/api/error/failures.dart';

class State<T, E extends Failures> {
  T _data;
  E _error;

  State({
    @required T data,
    @required E error,
  }) : assert(data == null || error == null),
        _data = data,
        _error = error;

  E get error => _error;

  T get data => _data;

  factory State.success(T data) = SuccessState<T, E>;

  factory State.error(E error) = ErrorState<T, E>;

  bool get isHasError => error != null;

  bool get isHasData => data != null;

  Z fold<Z>(Z Function(T) success, Z Function(E) error) {
    if (isHasData) {
      return success(_data);
    } else {
      return error(_error);
    }
  }
}

class SuccessState<T, E extends Failures> extends State<T, E> {
  final T _data;

  SuccessState(this._data);
}

class ErrorState<T, E extends Failures> extends State<T, E> {
  final E _error;

  ErrorState(this._error);
}
