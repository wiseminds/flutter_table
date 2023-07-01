import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum FilterDataType {
  boolean([FilterOption.eq]),
  integer(FilterOption.values),
  float(FilterOption.values),
  string([
    FilterOption.eq,
  ]), //FilterOption.inQ
  date(FilterOption.values);

  final List<FilterOption> options;
  const FilterDataType(this.options);
}

enum FilterOption {
  eq('\$eq', 'Equals'),
  gt('\$gt', 'Greater than'),
  lt('\$lt', "Less than"),
  gte('\$gte', 'Greater or equals'),
  lte('\$lte', 'Less than or equals');
  // inQ('\$in', 'Options');

  final String queryOperator, label;
  const FilterOption(this.queryOperator, this.label);
}

class FilterDescription extends Equatable {
  final String key, label;
  final FilterDataType type;
  final List<DropdownMenuItem> dropdownItems;

  const FilterDescription(this.key, this.label, this.type,
      [this.dropdownItems = const []]);

  @override
  List<Object?> get props => [type, key, label, dropdownItems];
}

class Filter<T> {
  final FilterDescription description;
  final FilterOption option;
  final FilterValue value;

  Filter(this.description, this.value, this.option);
}

class FilterValue {
  final dynamic value;
  final List<dynamic>? values;

  FilterValue({this.value, this.values});
}
