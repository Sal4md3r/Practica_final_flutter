import '../../../domain/models/user.dart';
import '../../../domain/repositories/account_repository.dart';
import '../local/session_service.dart';
import '../remote/account_api.dart';

class AccountRepoImpl implements AccountRepository {
  AccountRepoImpl(this._accountAPI, this._sessionService);

  final AccountAPI _accountAPI;
  final SessionService _sessionService;

  @override
  Future<User?> getUserData() async {
    return _accountAPI.getAccount(
      await _sessionService.sessionId ?? '',
    );
  }
}
