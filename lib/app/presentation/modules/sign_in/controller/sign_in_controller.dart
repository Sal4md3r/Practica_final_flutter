import '../../../../domain/either.dart';
import '../../../../domain/enums.dart';
import '../../../../domain/models/user.dart';
import '../../../../domain/repositories/autentication_repo.dart';
import '../../../global/state_notifier.dart';
import 'sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(
    super.state, {
    required this.authenticationRepository,
  });

  SignInState _state = SignInState();

  final AuthenticationRepo authenticationRepository;

  void onUserNameChanged(String text) {
    onlyUpdate(
      state.copyWith(
        username: text.toLowerCase(),
      ),
    );
  }

  void onPasswordChanged(String text) {
    onlyUpdate(
      state.copyWith(
        password: text.replaceAll(' ', ''),
      ),
    );
  }

  void onFetchingChanged(bool value) {
    state = state.copyWith(fetching: value);
  }

  Future<Either<SignInFailure, User>> submit() async {
    state = state.copyWith(fetching: true);
    final result =
        await authenticationRepository.signIn(state.username, state.password);

    result.when(
      (_) => state = state.copyWith(fetching: false),
      (_) => null,
    );

    return result;
  }
}
