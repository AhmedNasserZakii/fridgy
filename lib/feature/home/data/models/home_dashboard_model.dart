import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/home/data/models/kitchen_summary_model.dart';
import 'package:fridgy/feature/home/data/models/suggestion_model.dart';
import 'package:fridgy/feature/home/data/models/weekly_impact_model.dart';
import 'package:fridgy/feature/home/domain/entities/home_dashboard_entity.dart';
import 'package:fridgy/feature/inventory/data/models/food_item_model.dart';

class HomeDashboardModel {
  const HomeDashboardModel({
    required this.kitchenSummary,
    required this.unreadNotificationsCount,
    required this.useFirst,
    this.weeklyImpact,
    this.suggestion,
  });

  final KitchenSummaryModel kitchenSummary;
  final int unreadNotificationsCount;
  final List<FoodItemModel> useFirst;
  final WeeklyImpactModel? weeklyImpact;
  final SuggestionModel? suggestion;

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    final useFirstRaw = json[ApiKeys.useFirst];
    final weeklyRaw = json[ApiKeys.weeklyImpact];
    final suggestionRaw = json[ApiKeys.suggestion];

    return HomeDashboardModel(
      kitchenSummary: KitchenSummaryModel.fromJson(
        json[ApiKeys.kitchenSummary] as Map<String, dynamic>,
      ),
      unreadNotificationsCount: json[ApiKeys.unreadNotificationsCount] as int,
      useFirst: useFirstRaw is List
          ? useFirstRaw
                .whereType<Map<String, dynamic>>()
                .map(FoodItemModel.fromJson)
                .toList()
          : const [],
      weeklyImpact: weeklyRaw is Map<String, dynamic>
          ? WeeklyImpactModel.fromJson(weeklyRaw)
          : null,
      suggestion: suggestionRaw is Map<String, dynamic>
          ? SuggestionModel.fromJson(suggestionRaw)
          : null,
    );
  }

  HomeDashboardEntity toEntity() {
    return HomeDashboardEntity(
      totalItems: kitchenSummary.totalItems,
      expiringSoonCount: kitchenSummary.expiringSoonCount,
      unreadNotificationsCount: unreadNotificationsCount,
      useFirst: useFirst.map((e) => e.toEntity()).toList(),
      weeklyImpact: weeklyImpact?.toEntity(),
      suggestion: suggestion?.toEntity(),
    );
  }
}
