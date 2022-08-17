import '../table_data_source.dart';

mixin SelectionTableMixin<T> on BaseTableDataSource<T> {
  Set<int> _selected = const {};
  Set<int> get selected => _selected;

  void setRowSelection(int key, bool? selected) {
    if (selected == false) {
      _selected.remove(key);
    } else {
      _selected = {..._selected, key};
    }

    notifyListeners();
  }

  List<T> get selectedData => _selected.map((e) => data![e]).toList();

  void clearSelection() {
    _selected = const {};
    notifyListeners();
  }

  void selectAll() {
    _selected = Set.from(List.generate(rowCount, (index) => index));
    notifyListeners();
  }

  void toggleRowSelection(int index) {
    if (_selected.contains(index)) {
      _selected.remove(index);
    } else {
      _selected.add(index);
    }
    notifyListeners();
  }

  void deselectAll() {
    clearSelection();
  }

  void toggleAllSelection(bool? selected) {
    (selected == false) ? deselectAll() : selectAll();
  }
}
