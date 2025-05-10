import 'dart:math';

import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_table/src/preference.dart';
import 'package:equatable/equatable.dart';

import '../models/sort_query.dart';

part 'table_state.dart';
part 'table_repository.dart';

class TableCubit<T> extends Cubit<TableState<T>> {
  final TableRepository<T> _repository;

  TableCubit(this._repository) : super(TableState.initial());
  // final RefreshController refreshController =
  //     RefreshController(initialLoadStatus: LoadStatus.idle);

  setLoading() {
    emit(state.loading());
  }

  loadingStopped() {
    emit(state.copyWith());
  }

  Future<void> load({bool loadCurrent = false, SortQuery? sort}) async {
    emit(state.loading());
    var perPage = await Preference().getInt(Preference.perPage);
    var query = await state.buildQuery;
    if (!loadCurrent) query.addAll({'perPage': perPage, 'page': 1});
    if (sort != null) query.addAll(sort.toMap);

    // print(query);
    var response = await _repository.load(query);

    print(response.pagination);
    var p = response.pagination;
    if (response.isSuccessful) {
      emit(state.copyWith(
          data: response.body,
          page: p?.page,
          perPage: p?.limit,
          pages: p?.pages,
          total: p?.total));
    } else {
      emit(state.copyWith(message: (response.error as ApiError?)?.message));
    }
  }

  Future<void> loadNext([SortQuery? sort]) async {
    emit(state.loading());
    var q = state.buildNextQuery;
    if (sort != null) q.addAll(sort.toMap);
    var response = await _repository.load(q);

    var p = response.pagination;
    if (response.isSuccessful) {
      emit(state.copyWith(
          data: List.of([...?state.data, ...?response.body]),
          perPage: p?.limit,
          page: p?.page,
          pages: p?.pages,
          total: p?.total));
    } else {
      emit(state.copyWith(message: (response.error as ApiError?)?.message));
    }
  }

  Future<void> loadPrev([SortQuery? sort]) async {
    emit(state.copyWith(page: (state.page ?? 2) - 1));
  }
}
