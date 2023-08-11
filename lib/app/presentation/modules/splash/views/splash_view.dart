import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/autentication_repo.dart';
import '../../../../domain/repositories/conectivity_repo.dart';
import '../../../global/controllers/session_controller.dart';
import '../../../routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    final routeName = await () async {
      final ConectivityRepo connectivityRepo = context.read();
      final AuthenticationRepo authenticationRepo = context.read();
      final AccountRepository accountRepository = context.read();
      final SessionController sessionController = context.read();

      final hasInternet = await connectivityRepo.hasInternet;

      if (!hasInternet) {
        return Routes.signIn;
      }

      final hasSession = await authenticationRepo.isSignedIn;

      if (!hasSession) {
        return Routes.signIn;
      }

      final user = await accountRepository.getUserData();

      if (user != null) {
        sessionController.setUser(user);
        return Routes.home;
      }

      return Routes.signIn;
    }();

    if (mounted) {
      _goTo(routeName);
    }
  }

  void _goTo(String routename) {
    Navigator.pushReplacementNamed(context, routename);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
