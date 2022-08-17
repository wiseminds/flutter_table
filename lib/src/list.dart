// // import 'package:built_collection/built_collection.dart';
// import 'package:data_table_2/data_table_2.dart';
// // import 'package:data_tables/data_tables.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'cubit/selected_cubit.dart';
// import 'cubit/table_cubit.dart';
// import 'cubit/table_data_source.dart';
// import 'models/sort_query.dart';

// abstract class TableListState<W extends StatefulWidget, T, S> extends State<W> {
//   late TableCubit<T> cubit;
//   late SelectedCubit<S> selectedCubit;
//   late TableRepository<T> repository;
//   List<Widget> get actions => [];
//   List<Widget> get selectedActions => [];
//   double? get height => MediaQuery.of(context).size.height; // - 100;
//   double get padding => 20.0;
//   late PaginatorController paginatorController;

//   bool sortAscending = true;
//   int sortColumnIndex = 0;
//   late TableDataSource<T> source;

//   SortQuery? sort;
//   // late TableDataSource dataSource;
//   @override
//   void initState() {
//     cubit = TableCubit<T>(repository);
//     selectedCubit = SelectedCubit();
//     paginatorController = PaginatorController();
//     // dataSource = TableDataSource(
//     //     (i) => BsDataRow(index: i, cells: [
//     //           BsDataCell(Text('hgfdghjgfgh')),
//     //           BsDataCell(Text('hgfdghjgfgh')),
//     //           BsDataCell(Text('hgfdghjgfgh')),
//     //         ]),
//     //     cubit);
//     super.initState();
//     cubit.load(sort: sort);
//   }

//   @override
//   void dispose() {
//     cubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//           checkboxTheme: CheckboxThemeData(
//         side: MaterialStateBorderSide.resolveWith(
//             (_) => const BorderSide(width: 1, color: Colors.blue)),
//         fillColor: MaterialStateProperty.all(Colors.red),
//         checkColor: MaterialStateProperty.all(Colors.white),
//       )),
//       child: BlocBuilder<TableCubit<T>, TableState<T>>(
//           bloc: cubit,
//           builder: (context, state) {
//             var perPage = (state.perPage ?? 10);
//             var first =
//                 (((state.page ?? 1) - 1) * (state.perPage ?? 10)).toInt();
//             return Padding(
//               padding: EdgeInsets.all(padding),
//               child: Material(
//                   color: Colors.white,
//                   elevation: 10,
//                   shadowColor: Theme.of(context).primaryColor.withOpacity(.2),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0)),
//                   child: Padding(
//                     padding: EdgeInsets.all(0),
//                     child: Stack(
//                       children: [
//                         Container(
//                           height: 60,
//                           color: Theme.of(context).primaryColor.withOpacity(.1),
//                         ),
//                         SizedBox(
//                           height: height,
//                           child: AsyncPaginatedDataTable2(
//                               horizontalMargin: 40,
//                               checkboxHorizontalMargin: 50,
//                               // columnSpacing: 100,
//                               // actions: source.selectedRowCount > 0
//                               //     ? selectedActions
//                               //     : null,
//                               onSelectAll: (val) => (val == false)
//                                   ? source.deselectAll()
//                                   : source.selectAll(),
//                               wrapInCard: false,
//                               showFirstLastButtons: true,
//                               // header:
//                               //     source.selectedRowCount > 0 ? SizedBox() : null,
//                               // header: Row(
//                               //     mainAxisAlignment:
//                               //         MainAxisAlignment.spaceBetween,
//                               //     mainAxisSize: MainAxisSize.max,
//                               //     children: [
//                               //       Text(
//                               //         title,
//                               //       )
//                               // _TitledRangeSelector(
//                               //     range: const RangeValues(150, 600),
//                               //     onChanged: (v) {
//                               //       // If the curren row/current page happens to be larger than
//                               //       // the total rows/total number of pages what would happen is determined by
//                               //       // [pageSyncApproach] field
//                               //       _dessertsDataSource!.caloriesFilter = v;
//                               //     },
//                               //     key: _rangeSelectorKey,
//                               //     title: 'AsyncPaginatedDataTable2',
//                               //     caption: 'Calories'),
//                               // if (kDebugMode && getCurrentRouteOption(context) == custPager)
//                               //   Row(children: [
//                               //     OutlinedButton(
//                               //         onPressed: () => _controller.goToPageWithRow(25),
//                               //         child: const Text('Go to row 25')),
//                               //     OutlinedButton(
//                               //         onPressed: () => _controller.goToRow(5),
//                               //         child: const Text('Go to row 5'))
//                               //   ]),
//                               // if (getCurrentRouteOption(context) == custPager)
//                               // PageNumber(controller: _controller)
//                               // ]),
//                               rowsPerPage: perPage,
//                               autoRowsToHeight: true,
//                               sortColumnIndex: source.sortIndex,
//                               sortAscending: source.sortAscending,

//                               // Default - do nothing, autoRows - goToLast, other - goToFirst
//                               pageSyncApproach: PageSyncApproach.doNothing,
//                               minWidth: 600,
//                               dataRowHeight: 50,
//                               headingRowHeight: 60,
//                               // lmRatio: 2,smRatio: 6,
//                               showCheckboxColumn: true,
//                               fit: FlexFit.loose,
//                               border: TableBorder(
//                                   // top:
//                                   //     const BorderSide(color: Colors.black),
//                                   // bottom:
//                                   //     BorderSide(color: Colors.grey[300]!),
//                                   // left:
//                                   //     BorderSide(color: Colors.grey[300]!),
//                                   // right:
//                                   //     BorderSide(color: Colors.grey[300]!),
//                                   // verticalInside:
//                                   //     BorderSide(color: Colors.grey[300]!),
//                                   // horizontalInside: const BorderSide(
//                                   //     color: Colors.red, width: .051)
//                                   ),
//                               onRowsPerPageChanged: (value) {
//                                 // No need to wrap into setState, it will be called inside the widget
//                                 // and trigger rebuild
//                                 //setState(() {
//                                 print('Row per page changed to $value');
//                                 //TODO:
//                                 // context.read<TableCubit<T>>(). = value!;
//                                 //});
//                               },
//                               initialFirstRowIndex: first,
//                               onPageChanged: (rowIndex) {
//                                 //TODO:
//                                 print('page changed: $rowIndex');
//                               },
//                               // sortColumnIndex: _sortColumnIndex,//TODO:
//                               // sortAscending: _sortAscending, //TODO:
//                               // onSelectAll: (select) => select != null && select
//                               //     ? (getCurrentRouteOption(context) != selectAllPage
//                               //         ? _dessertsDataSource!.selectAll()
//                               //         : _dessertsDataSource!.selectAllOnThePage())
//                               //     : (getCurrentRouteOption(context) != selectAllPage
//                               //         ? _dessertsDataSource!.deselectAll()
//                               //         : _dessertsDataSource!
//                               //             .deselectAllOnThePage()),
//                               controller: paginatorController,
//                               hidePaginator: false,
//                               columns: columns,
//                               empty: Center(
//                                   child: Container(
//                                       padding: const EdgeInsets.all(20),
//                                       color: Colors.grey[200],
//                                       child: const Text('No data'))),
//                               loading:
//                                   Center(child: CupertinoActivityIndicator()),
//                               // errorBuilder: (e) => _ErrorAndRetry(e.toString(),
//                               //     () => _dessertsDataSource!.refreshDatasource()),
//                               source: source),
//                         ),
//                         // Positioned(
//                         //     // top: Responsive.isMobile(context) ? 10 : null,
//                         //     // bottom: Responsive.isMobile(context) ? null : 10,
//                         //     bottom: 10,
//                         //     left: 20,
//                         //     child: Perpage(
//                         //         onChanged: (v) => cubit.load(sort: sort))),
//                       ],
//                     ),
//                   )),
//             );
//           }),
//     );
//   }

//   List<DataColumn> get columns => source.column
//       .map(
//         (e) => DataColumn(
//             numeric: e.numeric,
//             onSort: source.sort,
//             label: Text(
//               e.title,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             )),
//       )
//       .toList();
//   String get title;

//   DataRow buildRow(T role, index, List<S> selected);

//   // void onSort(int? index, bool ascending) {}
//   // void onSelectAll(bool? selected);
// }
