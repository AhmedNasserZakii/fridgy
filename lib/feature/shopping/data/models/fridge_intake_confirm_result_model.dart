import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_confirm_result_entity.dart';

class FridgeIntakeConfirmResultModel {
  const FridgeIntakeConfirmResultModel({
    required this.intakeId,
    required this.createdInventoryIds,
    required this.createdCount,
  });

  final String intakeId;
  final List<String> createdInventoryIds;
  final int createdCount;

  factory FridgeIntakeConfirmResultModel.fromJson(Map<String, dynamic> json) {
    final ids = json[ApiKeys.createdInventoryIds] as List<dynamic>? ?? const [];
    return FridgeIntakeConfirmResultModel(
      intakeId: json[ApiKeys.intakeId] as String,
      createdInventoryIds: ids.map((e) => e as String).toList(),
      createdCount: json[ApiKeys.createdCount] as int,
    );
  }

  FridgeIntakeConfirmResultEntity toEntity() {
    return FridgeIntakeConfirmResultEntity(
      intakeId: intakeId,
      createdInventoryIds: createdInventoryIds,
      createdCount: createdCount,
    );
  }
}
