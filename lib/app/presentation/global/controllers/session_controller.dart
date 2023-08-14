import '../../../domain/models/user.dart';
import '../../../domain/repositories/autentication_repo.dart';
import '../state_notifier.dart';

class SessionController extends StateNotifier<User?> {
  SessionController({
    required this.authenticationRepo,
  }) : super(null);

  final AuthenticationRepo authenticationRepo;
  void setUser(User user) {
    state = user;
  }

  Future<void> signOut() async {
    await authenticationRepo.signOut();
    onlyUpdate(null);
  }
}
