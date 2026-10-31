import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/home/domain/entities/suggestion_entity.dart';
import 'package:fridgy/feature/home/domain/entities/weekly_impact_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';

class HomeDashboardEntity extends Equatable {
  const HomeDashboardEntity({
    required this.totalItems,
    required this.expiringSoonCount,
    required this.unreadNotificationsCount,
    required this.useFirst,
    this.weeklyImpact,
    this.suggestion,
  });

  final int totalItems;
  final int expiringSoonCount;
  final int unreadNotificationsCount;
  final List<FoodItemEntity> useFirst;
  final WeeklyImpactEntity? weeklyImpact;
  final SuggestionEntity? suggestion;

  @override
  List<Object?> get props => [
    totalItems,
    expiringSoonCount,
    unreadNotificationsCount,
    useFirst,
    weeklyImpact,
    suggestion,
  ];
}
