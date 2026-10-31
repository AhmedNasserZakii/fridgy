import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';
import 'package:fridgy/feature/inventory/data/data_source/recent_searches_local_data_source.dart';
import 'package:fridgy/feature/inventory/domain/params/search_params.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo.dart';
import 'package:fridgy/feature/inventory/presentation/logic/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this._inventoryRepo,
    required RecentSearchesLocalDataSource recentSearches,
    required AuthRepo authRepo,
  }) : _recentSearches = recentSearches,
       super(
         SearchState(
           recentSearches: recentSearches.getRecent(),
           firstName: authRepo.getCachedUser()?.firstName ?? '',
         ),
       );

  final InventoryRepo _inventoryRepo;
  final RecentSearchesLocalDataSource _recentSearches;

  static const int _minChars = 2;
  static const Duration _debounce = Duration(milliseconds: 400);
  static const int _pageSize = 20;

  Timer? _debounceTimer;

  /// Monotonic token used to ignore results of stale (superseded) requests.
  int _queryToken = 0;

  /// Debounced text-field input (D8).
  void onQueryChanged(String value) {
    final query = value.trim();
    _debounceTimer?.cancel();

    if (query.length < _minChars) {
      // Cancel any in-flight request and fall back to recent searches.
      _queryToken++;
      emit(
        state.copyWith(
          status: SearchStatus.idle,
          query: query,
          items: const [],
          recentSearches: _recentSearches.getRecent(),
          clearMeta: true,
          clearMessage: true,
        ),
      );
      return;
    }

    _debounceTimer = Timer(_debounce, () => _runSearch(query));
  }

  /// Immediate search (keyboard search button or tapping a recent search).
  Future<void> submit(String value) async {
    final query = value.trim();
    _debounceTimer?.cancel();
    if (query.length < _minChars) {
      onQueryChanged(value);
      return;
    }
    await _runSearch(query, saveRecentAlways: true);
  }

  Future<void> retry() async {
    if (state.query.trim().length >= _minChars) {
      await _runSearch(state.query.trim());
    }
  }

  Future<void> _runSearch(String query, {bool saveRecentAlways = false}) async {
    final token = ++_queryToken;
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        query: query,
        clearMessage: true,
      ),
    );

    final result = await _inventoryRepo.search(
      SearchParams(q: query, page: 1, limit: _pageSize),
    );
    if (isClosed || token != _queryToken) return;

    await result.fold(
      (failure) async => emit(
        state.copyWith(status: SearchStatus.failure, message: failure.message),
      ),
      (data) async {
        if (data.items.isEmpty) {
          emit(
            state.copyWith(
              status: SearchStatus.empty,
              items: const [],
              meta: data.meta,
            ),
          );
          if (saveRecentAlways) await _saveRecent(query);
        } else {
          emit(
            state.copyWith(
              status: SearchStatus.success,
              items: data.items,
              meta: data.meta,
            ),
          );
          await _saveRecent(query);
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (state.status != SearchStatus.success || !state.hasMore) return;
    final meta = state.meta;
    if (meta == null) return;

    final token = _queryToken;
    emit(state.copyWith(status: SearchStatus.loadingMore));

    final result = await _inventoryRepo.search(
      SearchParams(q: state.query, page: meta.page + 1, limit: _pageSize),
    );
    if (isClosed || token != _queryToken) return;

    result.fold(
      (_) => emit(state.copyWith(status: SearchStatus.success)),
      (data) => emit(
        state.copyWith(
          status: SearchStatus.success,
          items: [...state.items, ...data.items],
          meta: data.meta,
        ),
      ),
    );
  }

  Future<void> _saveRecent(String query) async {
    await _recentSearches.add(query);
    if (isClosed) return;
    emit(state.copyWith(recentSearches: _recentSearches.getRecent()));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
