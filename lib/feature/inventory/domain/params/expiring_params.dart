import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class ExpiringParams extends Equatable {
  const ExpiringParams({
    this.sort = 'expiry_asc',
    this.storage,
    this.page = 1,
    this.limit = 20,
  });

  final String sort;
  final StorageLocation? storage;
  final int page;
  final int limit;

  Map<String, dynamic> toQuery() {
    return {
      ApiKeys.sort: sort,
      if (storage != null) ApiKeys.storage: storage!.name,
      ApiKeys.page: page,
      ApiKeys.limit: limit,
    };
  }

  @override
  List<Object?> get props => [sort, storage, page, limit];
}
