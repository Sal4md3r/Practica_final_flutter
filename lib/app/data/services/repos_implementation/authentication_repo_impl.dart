import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/user.dart';
import '../../../domain/repositories/autentication_repo.dart';
import '../remote/authentication_api.dart';

const _key = 'sessionId';

class AuthenticationRepoImpl implements AuthenticationRepo {
  AuthenticationRepoImpl(
    this._secureStorage,
    this._authApi,
  );

  final FlutterSecureStorage _secureStorage;
  final AuthenticationAPI _authApi;

  @override
  Future<User?> getUserData() {
    return Future.value(User());
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);

    return sessionId != null;
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
                await _secureStorage.write(key: _key, value: sessionId);
                return Either.right(User());
              },
            );
          },
        );
      },
    );
  }

  @override
  Future<void> signOut() {
    return _secureStorage.delete(key: _key);
  }
}
