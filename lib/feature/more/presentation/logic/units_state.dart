import 'package:equatable/equatable.dart';

class UnitsState extends Equatable {
  const UnitsState({
    this.region = 'egypt',
    this.language = 'en',
    this.measurement = 'metric',
    this.currency = 'egp',
  });

  final String region;
  final String language;
  final String measurement;
  final String currency;

  bool get isMetric => measurement == 'metric';
  bool get isEgp => currency == 'egp';

  UnitsState copyWith({
    String? region,
    String? language,
    String? measurement,
    String? currency,
  }) {
    return UnitsState(
      region: region ?? this.region,
      language: language ?? this.language,
      measurement: measurement ?? this.measurement,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [region, language, measurement, currency];
}
