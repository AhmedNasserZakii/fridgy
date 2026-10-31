import 'package:equatable/equatable.dart';

class FridgeIntakeConfirmResultEntity extends Equatable {
  const FridgeIntakeConfirmResultEntity({
    required this.intakeId,
    required this.createdInventoryIds,
    required this.createdCount,
  });

  final String intakeId;
  final List<String> createdInventoryIds;
  final int createdCount;

  @override
  List<Object?> get props => [intakeId, createdInventoryIds, createdCount];
}
