// import 'package:flutter_table/core/extensions/index.dart';
// import 'package:data_table_2/data_table_2.dart';
import 'package:data_table_2/data_table_2.dart';
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
  final bool mini, showPerpageOnTop;
  String get searchHintText => 'Search';
  Color? get headerColor => null;
  Color? get backgroundColor => null;
  Color? get dividerColor => null;

  CheckboxThemeData? datarowCheckboxTheme, headingCheckboxTheme;

  TableListState({this.showPerpageOnTop = true, this.mini = false});
  List<Widget> get actions => [];
  List<Widget> get selectedActions => [];
  // double? get height => MediaQuery.of(context).size.height - 100;
  double get padding => 20.0;
  double get minWidth => 1200;
  // late PaginatorController paginatorController;

  bool sortAscending = true;
  bool showTitle = true;
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
    source.addListener(_handleDataSourceChanged);
    Future.delayed(const Duration(milliseconds: 500), source.load);
  }

  @override
  void dispose() {
    // cubit.close();
    source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
        data: Theme.of(context).copyWith(
            dataTableTheme: DataTableThemeData(
              dataTextStyle: source.rowTextStyle
                  .copyWith(color: isDark ? Colors.white70 : Colors.black87),
              dividerThickness: .5,
              horizontalMargin: 20,
              checkboxHorizontalMargin: 20,
              // dataRowMinHeight: 90,
              columnSpacing: 60,
              headingRowHeight: 50,
              headingTextStyle: source.headerTextStyle
                  .copyWith(color: isDark ? Colors.white70 : Colors.black87),
            ),
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              side: WidgetStateBorderSide.resolveWith((_) => BorderSide(
                  width: .4, color: isDark ? Colors.white70 : Colors.black87)),
              fillColor: WidgetStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              checkColor: WidgetStateProperty.all(Colors.white),
            )),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: padding, left: padding, right: padding),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // NestedScrollView(
              //     headerSliverBuilder: (context, innerBoxIsScrolled) => [],
              //     body:
              Column(
                children: [
                  if (!mini && showTitle)
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
                  if (!(mini || source.filterDescription.isEmpty))
                    Row(children: [
                      const Spacer(),
                      FilterView(
                        mini: mini,
                        source: source,
                        empty:
                            SizedBox(height: (!mini && showTitle) ? 60.0 : 0),
                        // onChanged: (filter) {
                        //   source.setFilter(filter);
                        // },
                      ),
                    ]),
                  // if (!mini && showTitle) const SizedBox(height: 60.0),
                  // 40.0.h,

                  // if (!mini) Row(children: [const Spacer(), ...actions]),

                  LayoutBuilder(builder: (context, cons) {
                    var search = SizedBox(
                        width: 400,
                        height: 70,
                        child: TextFormField(
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: InputDecoration(
                                hintText: searchHintText,
                                prefixIcon: const Icon(Icons.search),
                                hintStyle:
                                    Theme.of(context).textTheme.bodySmall,
                                labelStyle:
                                    Theme.of(context).textTheme.bodySmall,
                                isDense: true,
                                fillColor: Colors.transparent,
                                filled: true,
                                contentPadding: const EdgeInsets.all(10)
                                // errorBorder: InputBorder.none,
                                // border: InputBorder.none,
                                ),
                            onChanged: source.setQuery));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cons.maxWidth < 800)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              // if (!mini) Perpage(source: source),
                              if (!mini) const SizedBox(width: 20.0),
                              ...actions
                            ],
                          ),
                        if (cons.maxWidth < 800)
                          search
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              search,
                              if (cons.maxWidth >= 800) const Spacer(),
                              if (showPerpageOnTop &&
                                  (!mini || (cons.maxWidth >= 800)))
                                Perpage(source: source),
                              if (!mini || (cons.maxWidth >= 800))
                                const SizedBox(width: 20.0),
                              ...actions
                            ],
                          ),
                      ],
                    );
                  }),

                  if (source.selected.isNotEmpty && !mini)
                    Material(
                      color: Theme.of(context).primaryColor.withOpacity(.2),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text('${source.selected.length} items Selected',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
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
                  // const SizedBox(height: 20.0),
                  Expanded(
                      // child:
                      // SingleChildScrollView(
                      //     child: SingleChildScrollView(
                      // physics: const PageScrollPhysics(),
                      // dragStartBehavior: DragStartBehavior.down,
                      // scrollDirection: Axis.horizontal,
                      // child: ConstrainedBox(
                      //     constraints: BoxConstraints(
                      //         minWidth:
                      //             MediaQuery.of(context).size.width -
                      //                 300),
                      child: Material(
                    color: backgroundColor ?? Colors.transparent,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DataTable2(
                          minWidth: minWidth,

                          datarowCheckboxTheme: datarowCheckboxTheme ??
                              CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1)),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                side: WidgetStateBorderSide.resolveWith((_) =>
                                    BorderSide(
                                        width: .4,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black87)),
                                fillColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                checkColor: WidgetStateProperty.all(
                                    isDark ? Colors.white70 : Colors.black87),
                              ),
                          headingCheckboxTheme: headingCheckboxTheme ??
                              CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1)),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                side: WidgetStateBorderSide.resolveWith((_) =>
                                    BorderSide(
                                        width: .4,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black87)),
                                fillColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                checkColor: WidgetStateProperty.all(
                                    isDark ? Colors.white70 : Colors.black87),
                              ),
                          border: TableBorder(
                              bottom: BorderSide(
                                  color: dividerColor ?? Colors.transparent)),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color:
                                          dividerColor ?? Colors.transparent))),

                          // smRatio: 0.5,
                          // lmRatio: 4.5,
                          headingRowColor: WidgetStateProperty.all(
                              headerColor ??
                                  Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: .2)),
                          onSelectAll: source.toggleAllSelection,
                          sortColumnIndex: source.sortIndex,
                          sortAscending: source.sortAscending,
                          showBottomBorder: false,
                          showCheckboxColumn: !mini,
                          columns: columns, rows: rows,
                          // dataRowColor: WidgetStatePropertyAll(backgroundColor),
                          // source: source
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: source.isLoading,
                                builder: (c, s, w) => s || source.rowCount > 0
                                    ? const SizedBox()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.search,
                                                size: 90,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text('No data here')
                                          ]))),
                      ],
                    ),
                  )),
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
              ),

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
