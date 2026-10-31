import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/home/domain/entities/money_entity.dart';

class MoneyModel {
  const MoneyModel({required this.amount, required this.currency});

  final num amount;
  final String currency;

  factory MoneyModel.fromJson(Map<String, dynamic> json) {
    return MoneyModel(
      amount: json[ApiKeys.amount] as num,
      currency: json[ApiKeys.currency] as String,
    );
  }

  MoneyEntity toEntity() => MoneyEntity(amount: amount, currency: currency);
}
