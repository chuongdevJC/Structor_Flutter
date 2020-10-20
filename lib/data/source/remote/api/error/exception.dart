class Exception {
  String message;
  String prefix;

  Exception({this.message, this.prefix});

  @override
  String toString() {
    return super.toString();
  }
}

class UnauthorizedException extends Exception {

}
