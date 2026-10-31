import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_confirm_result_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_line_entity.dart';

enum FridgeIntakeStatus { ready, submitting, success, failure }

class FridgeIntakeState extends Equatable {
  const FridgeIntakeState({
    required this.intake,
    this.status = FridgeIntakeStatus.ready,
    this.message,
    this.result,
    this.fieldErrors = const {},
  });

  final FridgeIntakeEntity intake;
  final FridgeIntakeStatus status;
  final String? message;
  final FridgeIntakeConfirmResultEntity? result;
  final Map<String, List<String>> fieldErrors;

  List<FridgeIntakeLineEntity> get lines => intake.lines;

  FridgeIntakeState copyWith({
    FridgeIntakeEntity? intake,
    FridgeIntakeStatus? status,
    String? message,
    FridgeIntakeConfirmResultEntity? result,
    Map<String, List<String>>? fieldErrors,
    bool clearMessage = false,
    bool clearResult = false,
  }) {
    return FridgeIntakeState(
      intake: intake ?? this.intake,
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
      result: clearResult ? null : (result ?? this.result),
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [intake, status, message, result, fieldErrors];
}
