import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';

class PaginationMetaModel {
  const PaginationMetaModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.lastPage,
  });

  final int page;
  final int limit;
  final int total;
  final int lastPage;

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      page: json[ApiKeys.page] as int,
      limit: json[ApiKeys.limit] as int,
      total: json[ApiKeys.total] as int,
      lastPage: json[ApiKeys.lastPage] as int,
    );
  }

  PaginationMeta toEntity() {
    return PaginationMeta(
      page: page,
      limit: limit,
      total: total,
      lastPage: lastPage,
    );
  }
}
