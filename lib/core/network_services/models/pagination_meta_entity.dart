import 'package:equatable/equatable.dart';

class PaginationMeta extends Equatable {
  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.lastPage,
  });

  final int page;
  final int limit;
  final int total;
  final int lastPage;

  bool get hasMore => page < lastPage;

  @override
  List<Object?> get props => [page, limit, total, lastPage];
}

class PaginatedList<T> extends Equatable {
  const PaginatedList({required this.items, required this.meta});

  final List<T> items;
  final PaginationMeta meta;

  @override
  List<Object?> get props => [items, meta];
}
