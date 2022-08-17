class ColumnDescription {
  final String title, key;
  final bool enableSort, numeric;

  ColumnDescription(this.title, this.key,
      {this.enableSort = true, this.numeric = false});
}
