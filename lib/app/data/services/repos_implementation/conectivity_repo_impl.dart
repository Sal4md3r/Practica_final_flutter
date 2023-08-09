import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../domain/repositories/conectivity_repo.dart';
import '../remote/internetChecker.dart';

class ConectivityRepoImpl implements ConectivityRepo {
  ConectivityRepoImpl(this._conectivity, this._internetChecker);

  final Connectivity _conectivity;
  final InternetChecker _internetChecker;

  @override
  Future<bool> get hasInternet async {
    final result = await _conectivity.checkConnectivity();

    if (result == ConnectivityResult.none) return false;

    return _internetChecker.hasInternet();
  }
}
