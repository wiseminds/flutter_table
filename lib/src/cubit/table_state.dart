part of 'table_cubit.dart';

@immutable
class TableState<T> extends Equatable {
  int get length => data?.length ?? 0;
  bool get hasNext => (page ?? 0) < (pages ?? 0);

  final List<T>? data;
  final bool isLoading;
  final String? message, order, query;
  final int? total, pages, page, chunkCount, perPage;

  const TableState(
      {this.order,
      this.query,
      this.perPage,
      this.total,
      this.chunkCount,
      this.pages,
      this.page,
      this.message,
      this.data,
      this.isLoading = false});

  factory TableState.initial() => const TableState();

  TableState<T> copyWith(
          {List<T>? data,
          String? message,
          String? order,
          String? query,
          int? total,
          int? pages,
          int? perPage,
          int? chunkCount,
          int? page}) =>
      TableState(
          order: order ?? this.order,
          query: query ?? this.query,
          perPage: perPage ?? this.perPage,
          data: data ?? this.data,
          message: message,
          chunkCount: chunkCount ?? this.chunkCount,
          page: page ?? this.page,
          pages: pages ?? this.pages,
          total: total ?? this.total);

  @override
  List<Object?> get props => [
        message,
        data,
        isLoading,
        page,
        pages,
        total,
        order,
        query,
        perPage,
        chunkCount
      ];

  @override
  String toString() => '''{
    message: $message,
    isLoading: $isLoading  
    page: $page, 
    pages: $pages 
    total: $total, 
    order: $order,
    chunkCount: $chunkCount, 
    query: $query, 
    perPage: $perPage,  
    data: data,
  }''';

  Future<Map<String, dynamic>> get buildQuery async => {
        'page': page,
        'perPage': await Preference().getInt(Preference.perPage),
      };

  Map<String, dynamic> get buildPrevQuery => {
        'page': min((pages ?? 1), (page ?? 1) - 1),
        'perPage': perPage,
      };
  Map<String, dynamic> get buildNextQuery => {
        'page': min((pages ?? 1), (page ?? 1) + 1),
        'perPage': perPage,
      };

  TableState<T> loading() => TableState<T>(
      data: data,
      message: message,
      page: page,
      isLoading: true,
      pages: pages,
      perPage: perPage,
      query: query,
      order: order,
      total: total);
}
