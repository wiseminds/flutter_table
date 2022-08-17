part of 'table_cubit.dart';

abstract class TableRepository<T> extends DataRepository {
  TableRepository(super.localRepository, super.remoteRepository);

  Future<ApiResponse<List<T>, T>> load(Map<String, dynamic> query);
  // Future<ApiResponse<BuiltList<T>, T>> loadNext(Map<String, dynamic> query);
  // Future<ApiResponse<BuiltList<T>, T>> loadPrev(int page);
}
