import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/local_storage/local_storage.dart';
import 'package:fridgy/feature/more/presentation/logic/units_state.dart';

class UnitsCubit extends Cubit<UnitsState> {
  UnitsCubit({required LocalStorage localStorage})
    : _localStorage = localStorage,
      super(
        UnitsState(
          region: localStorage.getUnitsRegion(),
          language: localStorage.getUnitsLanguage(),
          measurement: localStorage.getUnitsMeasurement(),
          currency: localStorage.getUnitsCurrency(),
        ),
      );

  final LocalStorage _localStorage;

  Future<void> setRegion(String value) async {
    await _localStorage.setUnitsRegion(value);
    if (!isClosed) emit(state.copyWith(region: value));
  }

  Future<void> setLanguage(String value) async {
    await _localStorage.setUnitsLanguage(value);
    await _localStorage.setLocaleLanguage(value);
    if (!isClosed) emit(state.copyWith(language: value));
  }

  Future<void> setMeasurement(String value) async {
    await _localStorage.setUnitsMeasurement(value);
    if (!isClosed) emit(state.copyWith(measurement: value));
  }

  Future<void> setCurrency(String value) async {
    await _localStorage.setUnitsCurrency(value);
    if (!isClosed) emit(state.copyWith(currency: value));
  }
}
