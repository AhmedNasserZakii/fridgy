import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/theme/theme_controller.dart';

class AppearanceCubit extends Cubit<ThemeMode> {
  AppearanceCubit({required ThemeController themeController})
    : _themeController = themeController,
      super(themeController.themeMode);

  final ThemeController _themeController;

  Future<void> select(ThemeMode mode) async {
    await _themeController.setThemeMode(mode);
    if (!isClosed) emit(mode);
  }
}
