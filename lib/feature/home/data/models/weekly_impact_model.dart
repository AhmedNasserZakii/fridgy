import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/home/data/models/money_model.dart';
import 'package:fridgy/feature/home/domain/entities/weekly_impact_entity.dart';

class WeeklyImpactModel {
  const WeeklyImpactModel({
    required this.savedItemsCount,
    required this.goalItemsCount,
    required this.estimatedSavings,
    required this.weekStart,
  });

  final int savedItemsCount;
  final int goalItemsCount;
  final MoneyModel estimatedSavings;
  final DateTime weekStart;

  factory WeeklyImpactModel.fromJson(Map<String, dynamic> json) {
    return WeeklyImpactModel(
      savedItemsCount: json[ApiKeys.savedItemsCount] as int,
      goalItemsCount: json[ApiKeys.goalItemsCount] as int,
      estimatedSavings: MoneyModel.fromJson(
        json[ApiKeys.estimatedSavings] as Map<String, dynamic>,
      ),
      weekStart: DateTime.parse(json[ApiKeys.weekStart] as String),
    );
  }

  WeeklyImpactEntity toEntity() {
    return WeeklyImpactEntity(
      savedItemsCount: savedItemsCount,
      goalItemsCount: goalItemsCount,
      estimatedSavings: estimatedSavings.toEntity(),
      weekStart: weekStart,
    );
  }
}
