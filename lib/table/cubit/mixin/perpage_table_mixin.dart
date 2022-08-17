import 'package:flutter/material.dart';
import 'package:flutter_table/table/preference.dart';

import '../table_data_source.dart';

mixin PerpageTableMixin<T> on BaseTableDataSource<T> {
  ValueNotifier<int> perPage = ValueNotifier(10);

  void setPerPage(int value) {
    perPage.value = value;
    Preference().setInt(Preference.perPage, value);
    // notifyListeners();
    load(1);
  }
}
