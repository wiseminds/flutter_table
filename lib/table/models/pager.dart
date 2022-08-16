import 'package:equatable/equatable.dart';

class Pager extends Equatable {
  final int page, pages, total;

  const Pager({this.page = 1, this.pages = 1, this.total = 0});

  @override
  List<Object?> get props => [page, pages, total];
}
