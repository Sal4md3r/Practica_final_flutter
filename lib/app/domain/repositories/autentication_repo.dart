import '../either.dart';
import '../enums.dart';
import '../models/user.dart';

abstract class AuthenticationRepo {
  Future<bool> get isSignedIn;
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  );
  Future<void> signOut();
}
