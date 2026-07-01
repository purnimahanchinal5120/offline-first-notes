import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService {
  final Connectivity connectivity;

  SyncService(
      this.connectivity,
      );

  Stream<List<ConnectivityResult>>
  get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}