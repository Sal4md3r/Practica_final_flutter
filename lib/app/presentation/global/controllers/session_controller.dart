import '../../../domain/models/user.dart';
import '../state_notifier.dart';

class SessionController extends StateNotifier<User?> {
  SessionController() : super(null);

  void setUser(User user) {
    state = user;
  }

  void signOut() {
    onlyUpdate(null);
  }
}
