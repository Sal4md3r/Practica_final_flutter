class SignInController {
  String _username = '', _password = '';
  bool _fetching = false;

  String get username => _username;
  String get password => _password;
  bool get fetching => _fetching;

  void onUserNameChanged(String text) {
    _username = text.trim();
  }

  void onPasswordChanged(String text) {
    _password = text.replaceAll(' ', '');
  }

  void onFetchingChanged(bool value) {
    _fetching = value;
  }
}
