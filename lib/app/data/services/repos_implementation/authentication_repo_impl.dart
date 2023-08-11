import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/user.dart';
import '../../../domain/repositories/autentication_repo.dart';
import '../local/session_service.dart';
import '../remote/account_api.dart';
import '../remote/authentication_api.dart';

class AuthenticationRepoImpl implements AuthenticationRepo {
  AuthenticationRepoImpl(
    this._authApi,
    this._sessionService,
    this._accountAPI,
  );

  final AuthenticationAPI _authApi;
  final SessionService _sessionService;
  final AccountAPI _accountAPI;

  @override
  Future<bool> get isSignedIn async {
    final sesionId = await _sessionService.sessionId;
    return sesionId != null;
  }

  @override
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  ) async {
    final requestToken = await _authApi.createRequestToken();

    return requestToken.when(
      (failure) => Either.left(failure),
      (requestToken) async {
        final sesionLogin = await _authApi.createSessionWLogin(
          username: username,
          password: password,
          requestToken: requestToken,
        );

        return sesionLogin.when(
          (failure) async => Either.left(failure),
          (newRequestToken) async {
            final sessionId = await _authApi.createSession(
              requestToken: newRequestToken,
            );

            return sessionId.when(
              (failure) => Either.left(failure),
              (sessionId) async {
                await _sessionService.saveSessionId(sessionId);

                final user = await _accountAPI.getAccount(sessionId);

                if (user == null) {
                  Either.left(SignInFailure.unknown);
                }

                return Either.right(user!);
              },
            );
          },
        );
      },
    );
  }

  @override
  Future<void> signOut() => _sessionService.signOut();
}
