import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fridgy/core/network_services/web_constant.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl({required this._connectivity});

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    if (WebConstant.useMocks) return true;

    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
