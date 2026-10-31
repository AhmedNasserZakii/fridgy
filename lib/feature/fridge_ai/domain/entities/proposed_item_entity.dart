import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';

class ProposedItemEntity extends Equatable {
  const ProposedItemEntity({
    required this.id,
    required this.name,
    this.quantity,
    this.unit,
    this.category,
    this.expiresAt,
    this.emoji,
  });

  final String id;
  final String name;

  /// Null while the assistant is still clarifying quantity.
  final num? quantity;
  final FoodUnit? unit;
  final FoodCategory? category;
  final DateTime? expiresAt;
  final String? emoji;

  bool get isComplete => quantity != null;

  @override
  List<Object?> get props => [
        id,
        name,
        quantity,
        unit,
        category,
        expiresAt,
        emoji,
      ];
}
