import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_line_entity.dart';

class ConfirmFridgeIntakeParams {
  const ConfirmFridgeIntakeParams({
    required this.intakeId,
    required this.lines,
  });

  final String intakeId;
  final List<FridgeIntakeLineEntity> lines;
}
