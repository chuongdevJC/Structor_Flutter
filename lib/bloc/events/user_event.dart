import 'package:equatable/equatable.dart';

//Sample code
abstract class UserGitEvent extends Equatable {}

class Fetch extends UserGitEvent {
  @override
  String toString() => "fetch";
}
