import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/home/domain/entities/money_entity.dart';

class WeeklyImpactEntity extends Equatable {
  const WeeklyImpactEntity({
    required this.savedItemsCount,
    required this.goalItemsCount,
    required this.estimatedSavings,
    required this.weekStart,
  });

  final int savedItemsCount;
  final int goalItemsCount;
  final MoneyEntity estimatedSavings;
  final DateTime weekStart;

  double get progress {
    if (goalItemsCount <= 0) return 0;
    final ratio = savedItemsCount / goalItemsCount;
    if (ratio < 0) return 0;
    if (ratio > 1) return 1;
    return ratio;
  }

  @override
  List<Object?> get props => [
    savedItemsCount,
    goalItemsCount,
    estimatedSavings,
    weekStart,
  ];
}
