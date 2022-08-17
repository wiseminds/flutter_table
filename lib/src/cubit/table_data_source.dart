import 'dart:math';
 
import 'package:data_repository/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_table/src/preference.dart'; 

import '../models/column_description.dart';
import '../models/pager.dart';
import 'mixin/filter_table_mixin.dart';
import 'mixin/pagination_table_mixin.dart';
import 'mixin/perpage_table_mixin.dart';
import 'mixin/selection_table_mixin.dart';
import 'mixin/sort_table_mixin.dart';
import 'table_cubit.dart';

abstract class BaseTableDataSource<T> extends DataTableSource {
  BaseTableDataSource(this.repository);
  List<T>? data;

  Future load([int? page]);
  List<ColumnDescription> get column;
  final TableRepository<T> repository;
  ValueNotifier<Pager?> pager = ValueNotifier(null);
}

abstract class TableDataSource<T> extends BaseTableDataSource<T>
    with
        PerpageTableMixin<T>,
        SortPageTableMixin<T>,
        SelectionTableMixin<T>,
        PaginationTableMixin<T>,
        FilterTableMixin<T> {
  // int _perPage = 10;
  // ValueNotifier<Pagination> currentPage = ValueNotifier(Pagination((b)=> b..));
  // int get perPage => _perPage;
  TableDataSource(super.repository, {int sortIndex = 0}) {
    print('TableDataSource created');
    this.sortIndex = sortIndex;
     Preference().getInt(Preference.perPage)
        .then((value) => perPage.value = value ?? perPage.value);
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selected.length;
  // int currentRowCount  0;
  @override
  int get rowCount => min(perPage.value, pager.value?.total ?? 0);

  String get sortColumn => column[sortIndex].key;
  List<DataCell> getCells(int i) => [];

  TextStyle get rowTextStyle =>
      const TextStyle(fontSize: 12, color: Colors.black87);
  TextStyle get headerTextStyle => const TextStyle(
      fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87);

  @override
  Future load([int? page]) async {
    // print(page);
    isLoading.value = true;
    var response = await repository.load({
      'sort': '${sortAscending ? '+' : '-'}$sortColumn',
      'page': page ?? currentPage,
      'limit': perPage.value,
      ...buildFilter
    });
    isLoading.value = false;
    if (!response.isSuccessful) {
      await Future.delayed(const Duration(milliseconds: 1000));
      throw (response.error as ApiError?)?.message ?? 'An error occurred';
    }
    var pagination = response.pagination;
    print('pagination: $pagination, $page');
    if (pagination != null) {
      pager.value = Pager(
          page: pagination.page, // ?? 1,
          total: pagination.total, // ?? 1,
          pages: pagination.pages);
    }
    data = response.body?.toList() ?? [];
    notifyListeners();
  }

  @override
  DataRow getRow(int i) {
    // var item = data![i];
    return DataRow(
        key: ValueKey(i),
        selected: selected.contains(i),
        // color: MaterialStateProperty.all(
        //     i.isEven ? AppColors.primary.withOpacity(.1) : Colors.white),
        // selected: selected.contains(  body.id),
        onSelectChanged: (i > (data?.length ?? 0) - 1)
            ? null
            : (selected) {
                setRowSelection(i, selected);
              },
        cells: (i > (data?.length ?? 0) - 1)
            ? [
                for (var c in column) const DataCell(Text(' ')),
              ]
            : getCells(i));
  }

  // refreshDatasource() {}
}
