import 'package:flutter/foundation.dart';

enum SortOptions { asc, desc }

class SortQuery {
  final String key;
  final SortOptions option;

  SortQuery(this.key, this.option);

  Map<String, dynamic> get toMap => {'s': '$key:${describeEnum(option)}'};
}
