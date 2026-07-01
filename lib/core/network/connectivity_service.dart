import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectionStream async* {
    await for (final result in _connectivity.onConnectivityChanged) {
      if (result.contains(ConnectivityResult.none)) {
        yield false;
      } else {
        final hasInternet =
        await InternetConnection().hasInternetAccess;
        yield hasInternet;
      }
    }
  }

  Future<bool> isConnected() async {
    final connectivity = await _connectivity.checkConnectivity();

    if (connectivity.contains(ConnectivityResult.none)) {
      return false;
    }

    return InternetConnection().hasInternetAccess;
  }
}