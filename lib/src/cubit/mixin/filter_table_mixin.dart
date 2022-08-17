// import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import '../../filter/filter_description.dart';
import '../table_data_source.dart';

mixin FilterTableMixin<T> on BaseTableDataSource<T> {
  List<FilterDescription> filterDescription = [];

  ValueNotifier<String> q = ValueNotifier('');
  ValueNotifier<List<Filter>> filters = ValueNotifier([]);

  updateFilter(List<Filter> filter) {
    filters.value = filter;
    load();
  }

  clearFilter() {
    filters.value = [];
    load();
  }

  setQuery(String q) {
    this.q.value = q;
    load();
  }

  Map<String, dynamic> get buildFilter {
    var query = <String, dynamic>{};
    for (var e in filters.value) {
      print(e);
      if (e.option == FilterOption.eq) {
        query.addAll({e.description.key: e.value.value});
      } else {
        query.addAll({
          e.description.key:
              '${e.option.queryOperator}:${(e.value.value)}' //(e.option == FilterOption.inQ) ? e.values :
        });
      }
    }
    if (q.value.isNotEmpty) {
      query.addAll({'q': q.value});
    }
    // print(query);
    return query;
  }
}
