import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fridgy/core/network_services/api_mode_controller.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl({required this._connectivity, required this._apiMode});

  final Connectivity _connectivity;
  final ApiModeController _apiMode;

  @override
  Future<bool> get isConnected async {
    if (_apiMode.useMocks) return true;

    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
