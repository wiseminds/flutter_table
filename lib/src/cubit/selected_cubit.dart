import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'selected_state.dart';

class SelectedCubit<T> extends Cubit<BuiltList<T>> {
  SelectedCubit() : super(BuiltList.of([]));

  update(List<T> values) => emit(values.toBuiltSet().toBuiltList());
  unselectAll() => emit(BuiltList.of([]));
  remove(T value) {
    var a = state.toList();
    a.remove(value);
    emit(a.toBuiltList());
  }

  add(T value) {
    var a = state.toList();
    a.add(value);
    emit(a.toBuiltList());
  }
}
