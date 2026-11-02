import 'package:flutter/foundation.dart';
import 'package:fridgy/core/local_storage/local_storage.dart';

/// Where API requests are answered from.
enum ApiMode {
  /// Local mock JSON from `assets/mocks/` (via `MockInterceptor`).
  local,

  /// The real backend at `WebConstant.baseUrl`.
  live,
}

/// Runtime switch between local mocks and the live backend, persisted
/// across launches. Read on every request, so a change applies immediately.
class ApiModeController extends ChangeNotifier {
  ApiModeController({required this._localStorage}) {
    _mode = _parse(_localStorage.getApiMode());
  }

  final LocalStorage _localStorage;
  late ApiMode _mode;

  ApiMode get mode => _mode;
  bool get useMocks => _mode == ApiMode.local;
  bool get isLive => _mode == ApiMode.live;

  Future<void> setMode(ApiMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    await _localStorage.setApiMode(mode.name);
    notifyListeners();
  }

  static ApiMode _parse(String? value) {
    return ApiMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ApiMode.local,
    );
  }
}
