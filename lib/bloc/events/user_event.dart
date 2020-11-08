import 'package:equatable/equatable.dart';

abstract class UserGitEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetch extends UserGitEvent {
  @override
  String toString() => "fetch";
}
