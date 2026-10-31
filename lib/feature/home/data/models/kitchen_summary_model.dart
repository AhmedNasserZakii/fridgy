import 'package:fridgy/core/network_services/api_keys.dart';

class KitchenSummaryModel {
  const KitchenSummaryModel({
    required this.totalItems,
    required this.expiringSoonCount,
  });

  final int totalItems;
  final int expiringSoonCount;

  factory KitchenSummaryModel.fromJson(Map<String, dynamic> json) {
    return KitchenSummaryModel(
      totalItems: json[ApiKeys.totalItems] as int,
      expiringSoonCount: json[ApiKeys.expiringSoonCount] as int,
    );
  }
}
