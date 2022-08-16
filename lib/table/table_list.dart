// import 'package:flutter_table/core/extensions/index.dart';
// import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'cubit/selected_cubit.dart';
// import 'cubit/table_cubit.dart';
import 'cubit/table_data_source.dart';
import 'filter/filter_view.dart';
import 'models/sort_query.dart';
import 'pagination/pagination_pages.dart';
import 'pagination/perpage.dart';

abstract class TableListState<W extends StatefulWidget, T> extends State<W> {
  // late TableCubit<T> cubit;
  // late SelectedCubit<S> selectedCubit;
  // late TableRepository<T> repository;
  final bool mini;
  String get searchHintText => 'Search';

  TableListState({this.mini = false});
  List<Widget> get actions => [];
  List<Widget> get selectedActions => [];
  double? get height => MediaQuery.of(context).size.height - 100;
  double get padding => 20.0;
  // late PaginatorController paginatorController;

  bool sortAscending = true;
  int sortColumnIndex = 0;
  late TableDataSource<T> source;

  SortQuery? sort;

  void _handleDataSourceChanged() {
    setState(() {});
  }

  @override
  void initState() {
    // cubit = TableCubit<T>(repository);
    // selectedCubit = SelectedCubit();
    // paginatorController = PaginatorController();
    super.initState();
    source
      ..load()
      ..addListener(_handleDataSourceChanged);
  }

  @override
  void dispose() {
    // cubit.close();
    source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            dataTableTheme: DataTableThemeData(
              dataTextStyle: source.rowTextStyle,
              dividerThickness: .5,
              horizontalMargin: 20,
              checkboxHorizontalMargin: 20,
              dataRowHeight: 70,
              columnSpacing: 60,
              headingRowHeight: 50,
              headingTextStyle: source.headerTextStyle,
            ),
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              side: MaterialStateBorderSide.resolveWith(
                  (_) => const BorderSide(width: .4, color: Colors.blueGrey)),
              fillColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              checkColor: MaterialStateProperty.all(Colors.white),
            )),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Stack(
            // fit: StackFit.expand,
            children: [
              NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                  body: ListView(
                    children: [
                      Row(
                        children: [
                          Text(title,
                              style: TextStyle(
                                  fontSize: mini ? 20 : 28,
                                  color: Theme.of(context).iconTheme.color,
                                  fontWeight: FontWeight.w500)),
                          const Spacer(),
                          // if (!mini)
                        ],
                      ),
                      const SizedBox(height: 40.0),
                      // 40.0.h,
                      FilterView(
                        mini: mini,
                        source: source,
                        // onChanged: (filter) {
                        //   source.setFilter(filter);
                        // },
                      ),
                      if (!mini) Row(children: [const Spacer(), ...actions]),
                      if (!mini)
                        Row(
                          children: [
                            SizedBox(
                                width: 400,
                                child: TextFormField(
                                    style: Theme.of(context).textTheme.caption,
                                    decoration: InputDecoration(
                                        hintText: searchHintText,
                                        prefixIcon: const Icon(Icons.search),
                                        hintStyle:
                                            Theme.of(context).textTheme.caption,
                                        labelStyle:
                                            Theme.of(context).textTheme.caption,
                                        isDense: true,
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        contentPadding: const EdgeInsets.all(10)
                                        // errorBorder: InputBorder.none,
                                        // border: InputBorder.none,
                                        ),
                                    onChanged: source.setQuery)),
                            const Spacer(),
                            Perpage(source: source),
                          ],
                        ),
                      if (source.selected.isNotEmpty && !mini)
                        Material(
                          color: Theme.of(context).primaryColor.withOpacity(.2),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Text('${source.selected.length} items Selected',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                                const Spacer(),
                                for (var item in selectedActions)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: item,
                                  )
                              ],
                            ),
                          ),
                        ),
                      // onChanged: (v) => cubit.load(sort: sort))),
                      const SizedBox(height: 20.0),
                      Material(
                          color: Colors.white,
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          child: SingleChildScrollView(
                              // dragStartBehavior: DragStartBehavior.down,
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.width -
                                            300),
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.2)),
                                  onSelectAll: source.toggleAllSelection,
                                  sortColumnIndex: source.sortIndex,
                                  sortAscending: source.sortAscending,
                                  showBottomBorder: false,
                                  showCheckboxColumn: !mini,
                                  columns: columns, rows: rows,
                                  // source: source
                                ),
                              ))),
                      if (!mini) const SizedBox(height: 20.0),
                      if (!mini)
                        Row(
                          children: [
                            Perpage(source: source),
                            const Spacer(),
                            PaginationPages(source: source)
                          ],
                        )
                    ],
                  )),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: source.isLoading,
                      builder: (c, s, w) => s
                          ? const Center(child: CupertinoActivityIndicator())
                          : const SizedBox())),
            ],
          ),
        ));
  }

  List<DataColumn> get columns => source.column
      .map(
        (e) => DataColumn(
            numeric: e.numeric,
            onSort: e.enableSort ? source.sort : null,
            tooltip: e.title,
            label: Text(e.title)),
      )
      .toList();

  List<DataRow> get rows =>
      [for (var i = 0; i < (source.rowCount); i++) source.getRow(i)];

  String get title;

  // DataRow buildRow(T role, index, List<S> selected);
}
