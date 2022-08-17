import '../table_data_source.dart';

mixin SortPageTableMixin<T> on BaseTableDataSource<T> {
  int sortIndex = 0;
  bool sortAscending = true;

  void sort(int index, bool ascending) {
    sortIndex = index;
    sortAscending = ascending;
    load();
  }
}
