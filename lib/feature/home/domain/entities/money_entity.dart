import 'package:equatable/equatable.dart';

class MoneyEntity extends Equatable {
  const MoneyEntity({required this.amount, required this.currency});

  final num amount;
  final String currency;

  /// e.g. "EGP 420" — whole amounts without decimals.
  String get display {
    final whole = amount == amount.roundToDouble() || amount is int;
    final amountText = whole ? amount.round().toString() : amount.toString();
    return '$currency $amountText';
  }

  @override
  List<Object?> get props => [amount, currency];
}
