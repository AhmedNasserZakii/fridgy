import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/option_entity.dart';

class OptionModel {
  const OptionModel({required this.id, required this.name});

  final String id;
  final String name;

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json[ApiKeys.id] as String,
      name: json[ApiKeys.name] as String,
    );
  }

  OptionEntity toEntity() => OptionEntity(id: id, name: name);
}
