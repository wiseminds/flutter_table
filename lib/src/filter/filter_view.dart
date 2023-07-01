// import 'package:admin/core/extensions/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cubit/table_data_source.dart';
import 'filter_description.dart';

class FilterView extends StatefulWidget {
  final TableDataSource source;
  final bool mini;
  const FilterView({Key? key, required this.source, required this.mini})
      : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final ValueNotifier<Map<Key, Filter>> _filters = ValueNotifier({});

  List<Key> filterKeys = [];

  @override
  void initState() {
    // filterKeys.add(UniqueKey());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mini || widget.source.filterDescription.isEmpty) {
      return const SizedBox();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      const SizedBox(height: 30),
      SizedBox(
        width: 300,
        child: Row(
          children: [
            const Spacer(),
            const Text('Filters'),
            const SizedBox(width: 20.0),
            IconButton(
                onPressed: () {
                  filterKeys.add(UniqueKey());
                  setState(() {});
                },
                icon: const Icon(Icons.add)),
          ],
        ),
      ),
      if (filterKeys.isNotEmpty)
        for (var i = 0; i < filterKeys.length; i++)
          // for (var item in filterKeys)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FilterItem(
              isLasItem: i == filterKeys.length - 1,
              // && filterKeys.length > 1,
              key: filterKeys[i],
              onRemove: () {
                _filters.value.remove(filterKeys[i]);
                filterKeys.remove(filterKeys[i]);
                if (filterKeys.isEmpty) {
                  widget.source.clearFilter();
                } else {
                  widget.source.updateFilter(_filters.value.values.toList());
                }
                setState(() {});
              },
              onAdd: () {
                filterKeys.add(UniqueKey());
                setState(() {});
              },
              description: widget.source.filterDescription,
              //  [
              //   FilterDescription('isActive', 'isActive', FilterDataType.boolean),
              //   FilterDescription(
              //       'firstName', 'First Name', FilterDataType.string),
              //   FilterDescription('lastName', 'Last Name', FilterDataType.string)
              // ],
              onChanged: (Filter value) {
                _filters.value[filterKeys[i]] = value;
              },
            ),
          ),
      // const SizedBox(height: 20.0),
      if (filterKeys.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      widget.source.updateFilter(_filters.value.values.toList());
                    },
                    child: const Text('Apply')),
                const SizedBox(width: 20.0),
                OutlinedButton(
                    onPressed: () {
                      filterKeys = [];
                      _filters.value = {};
                      widget.source.updateFilter(_filters.value.values.toList());
                      setState(() {});
                    },
                    child: const Text('Clear'))
              ]),
        ),
      // const SizedBox(height: 30.0)
    ]);
  }
}

class FilterItem extends StatefulWidget {
  final List<FilterDescription> description;
  final Function(Filter) onChanged;
  final Function() onRemove, onAdd;
  final bool isLasItem;
  const FilterItem(
      {Key? key,
      required this.description,
      required this.onChanged,
      required this.onRemove,
      required this.onAdd,
      this.isLasItem = false})
      : super(key: key);

  @override
  State<FilterItem> createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  ValueNotifier<FilterDescription?> selected = ValueNotifier(null);
  ValueNotifier<FilterOption?> queryOperator = ValueNotifier(null);
  ValueNotifier<FilterValue?> query = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10);
    return ValueListenableBuilder(
        valueListenable: selected,
        builder: (c, s, w) {
          return ValueListenableBuilder(
              valueListenable: queryOperator,
              builder: (c, s, w) {
                return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.start,
                    children: [
                      if (widget.isLasItem)
                        IconButton(
                            onPressed: widget.onAdd,
                            icon: const Icon(Icons.add)),
                      IconButton(
                          onPressed: widget.onRemove,
                          icon: const Icon(Icons.remove_circle)),
                      Material(
                        // color: Colors.white,
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(width: .1)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8.0),
                            child: SizedBox(
                                width: 100,
                                child: DropdownButton<FilterDescription>(
                                  isExpanded: true,
                                  // dropdownColor: Theme.of(context).canvasColor,
                                  onChanged: (val) {
                                    selected.value = val;
                                    queryOperator.value = null;
                                    query.value = null;
                                    // source.setPerPage(val ?? source.perPage.value);
                                  },
                                  icon: const Icon(Icons.unfold_more, size: 15),
                                  value: selected.value,
                                  underline: const SizedBox(),
                                  isDense: true,
                                  style: style,
                                  items: [
                                    for (var item in widget.description)
                                      DropdownMenuItem(
                                          value: item, child: Text(item.label)),
                                  ],
                                ))),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        // color: Colors.white,
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(width: .1)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8.0),
                            child: SizedBox(
                                width: 100,
                                child: DropdownButton<FilterOption>(
                                  isExpanded: true,
                                  onChanged: (val) {
                                    queryOperator.value = val;
                                    query.value = null;
                                  },
                                  icon: const Icon(Icons.unfold_more, size: 15),
                                  value: queryOperator.value,
                                  underline: const SizedBox(),
                                  isDense: true,
                                  style: style,
                                  items: [
                                    if (selected.value != null)
                                      for (var item
                                          in selected.value!.type.options)
                                        DropdownMenuItem(
                                            value: item,
                                            child: Text(item.label))
                                    else
                                      const DropdownMenuItem(
                                          value: null, child: Text('Operator')),
                                  ],
                                ))),
                      ),
                      const SizedBox(width: 10),
                      // if(selected.value?.type == FilterDataType.boolean)
                      // Material(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(side: BorderSide(width: .1)),
                      //   child: Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 10, vertical: 8.0),
                      //       child: TextField(
                      //         decoration: InputDecoration(
                      //           border: InputBorder.none,
                      //           hintText: 'Value',
                      //           hintStyle: style,
                      //         ),
                      //         style: style,
                      //       )),
                      // ),

                      if ((selected.value?.dropdownItems.length ?? 0) > 0)
                        ValueListenableBuilder(
                            valueListenable: query,
                            builder: (c, s, w) => Material(
                                  // color: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      side: BorderSide(width: .1)),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8.0),
                                      child: SizedBox(
                                          width: 100,
                                          child: Builder(builder: (context) {
                                            // Type T = selected
                                            //     .value!
                                            //     .dropdownItems[0]
                                            //     .value
                                            //     .runtimeType;
                                            return DropdownButton<String>(
                                              isExpanded: true,
                                              onChanged: (val) {
                                                query.value =
                                                    FilterValue(value: val);
                                                widget.onChanged(Filter(
                                                    selected.value!,
                                                    query.value!,
                                                    queryOperator.value!));
                                                // source.setPerPage(val ?? source.perPage.value);
                                              },
                                              icon: const Icon(
                                                  Icons.unfold_more,
                                                  size: 15),
                                              value: query.value?.value,
                                              underline: const SizedBox(),
                                              isDense: true,
                                              style: style,
                                              items: [
                                                for (var item in selected
                                                        .value?.dropdownItems ??
                                                    [])
                                                  item
                                              ],
                                            );
                                          }))),
                                ))
                      else if (selected.value?.type == FilterDataType.boolean)
                        ValueListenableBuilder(
                            valueListenable: query,
                            builder: (c, s, w) => Material(
                                  // color: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      side: BorderSide(width: .1)),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8.0),
                                      child: SizedBox(
                                          width: 100,
                                          child: DropdownButton<bool>(
                                            isExpanded: true,
                                            onChanged: (val) {
                                              query.value =
                                                  FilterValue(value: val);
                                              widget.onChanged(Filter(
                                                  selected.value!,
                                                  query.value!,
                                                  queryOperator.value!));
                                              // source.setPerPage(val ?? source.perPage.value);
                                            },
                                            icon: const Icon(Icons.unfold_more,
                                                size: 15),
                                            value: query.value?.value,
                                            underline: const SizedBox(),
                                            isDense: true,
                                            style: style,
                                            items: [
                                              const DropdownMenuItem(
                                                  value: true,
                                                  child: Text('true')),
                                              const DropdownMenuItem(
                                                  value: false,
                                                  child: Text('false')),
                                            ],
                                          ))),
                                ))
                      else if (selected.value?.type == FilterDataType.string)
                        Material(
                            // color: Colors.white,
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(width: .1)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8.0),
                                child: SizedBox(
                                    width: 100,
                                    height: 24,
                                    child: Center(
                                      child: TextFormField(
                                        style: style,
                                        onChanged: (val) {
                                          query.value = FilterValue(value: val);
                                          widget.onChanged(Filter(
                                              selected.value!,
                                              query.value!,
                                              queryOperator.value!));
                                          // source.setPerPage(val ?? source.perPage.value);
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'query',
                                            hintStyle: style,
                                            isDense: true),
                                      ),
                                    ))))
                      else if (selected.value?.type == FilterDataType.integer)
                        Material(
                            // color: Colors.white,
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(width: .1)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8.0),
                                child: SizedBox(
                                    width: 100,
                                    height: 24,
                                    child: Center(
                                      child: TextFormField(
                                        style: style,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (val) {
                                          query.value = FilterValue(value: val);
                                          widget.onChanged(Filter(
                                              selected.value!,
                                              query.value!,
                                              queryOperator.value!));
                                          // source.setPerPage(val ?? source.perPage.value);
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'query',
                                            hintStyle: style,
                                            isDense: true),
                                      ),
                                    )))),
                    ]);
              });
        });
  }
}
