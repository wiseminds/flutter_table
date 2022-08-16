// import 'package:flutter/material.dart';

import 'dart:math';

import '../table_data_source.dart';

mixin PaginationTableMixin<T> on BaseTableDataSource<T> {
  int get currentPage => pager.value?.page ?? 1;

  void next() {
    load(currentPage + 1);
  }

  void prev() {
    load(max(currentPage - 1, 1));
  }

  void toPage(int page) {
    load(page);
  }
}
