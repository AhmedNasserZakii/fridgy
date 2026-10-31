import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_line_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_source.dart';

class FridgeIntakeEntity extends Equatable {
  const FridgeIntakeEntity({
    required this.id,
    required this.source,
    required this.lines,
    required this.createdAt,
    this.sourceId,
  });

  final String id;
  final FridgeIntakeSource source;
  final String? sourceId;
  final List<FridgeIntakeLineEntity> lines;
  final DateTime createdAt;

  FridgeIntakeEntity copyWith({List<FridgeIntakeLineEntity>? lines}) {
    return FridgeIntakeEntity(
      id: id,
      source: source,
      sourceId: sourceId,
      lines: lines ?? this.lines,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, source, sourceId, lines, createdAt];
}
