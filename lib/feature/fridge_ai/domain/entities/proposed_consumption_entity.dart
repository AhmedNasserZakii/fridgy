import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';

class ProposedConsumptionEntity extends Equatable {
  const ProposedConsumptionEntity({
    required this.id,
    required this.inventoryItemId,
    required this.name,
    required this.quantity,
    this.unit,
  });

  final String id;
  final String inventoryItemId;
  final String name;
  final num quantity;
  final FoodUnit? unit;

  @override
  List<Object?> get props => [id, inventoryItemId, name, quantity, unit];
}
