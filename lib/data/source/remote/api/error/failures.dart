abstract class Failures {
  final String message = "";
}

class ServerFailure extends Failures {
  final _message;

  ServerFailure(this._message);

  @override
  String get message => _message;
}

class UnhandledFailure extends Failures {
  final _message;

  UnhandledFailure(this._message);

  @override
  String get message => _message;
}
