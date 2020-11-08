import 'package:equatable/equatable.dart';

abstract class BaseRequest extends Equatable {
  String get url;

  Map<String, dynamic> toJson();
}
