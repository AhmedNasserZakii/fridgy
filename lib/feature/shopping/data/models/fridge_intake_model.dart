import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/shopping/data/models/fridge_intake_line_model.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_source.dart';

class FridgeIntakeModel {
  const FridgeIntakeModel({
    required this.id,
    required this.source,
    required this.lines,
    required this.createdAt,
    this.sourceId,
  });

  final String id;
  final FridgeIntakeSource source;
  final String? sourceId;
  final List<FridgeIntakeLineModel> lines;
  final DateTime createdAt;

  factory FridgeIntakeModel.fromJson(Map<String, dynamic> json) {
    final rawLines = json[ApiKeys.lines] as List<dynamic>? ?? const [];
    return FridgeIntakeModel(
      id: json[ApiKeys.id] as String,
      source:
          FridgeIntakeSource.fromJson(json[ApiKeys.source] as String?) ??
          FridgeIntakeSource.list,
      sourceId: json[ApiKeys.sourceId] as String?,
      lines: rawLines
          .map((e) => FridgeIntakeLineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json[ApiKeys.createdAt] as String),
    );
  }

  FridgeIntakeEntity toEntity() {
    return FridgeIntakeEntity(
      id: id,
      source: source,
      sourceId: sourceId,
      lines: lines.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}
