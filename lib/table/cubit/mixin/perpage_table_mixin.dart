import 'package:admin/constants/pref_keys.dart';
import 'package:admin/data/local/preference_store/preference_store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../table_data_source.dart';

mixin PerpageTableMixin<T> on BaseTableDataSource<T> {
  ValueNotifier<int> perPage = ValueNotifier(10);

  void setPerPage(int value) {
    perPage.value = value;
    GetIt.I<PreferenceStore>().setInt(PrefKeys.isFirstOpen, value);
    // notifyListeners();
    load(1);
  }
}
