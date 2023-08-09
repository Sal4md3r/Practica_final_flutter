import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/autentication_repo.dart';
import '../../../../domain/repositories/conectivity_repo.dart';
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
    final connectivityRepo =
        Provider.of<ConectivityRepo>(context, listen: false);
    final authenticationRepo =
        Provider.of<AuthenticationRepo>(context, listen: false);

    final hasInternet = await connectivityRepo.hasInternet;

    if (hasInternet) {
      final hasSession = await authenticationRepo.isSignedIn;
      if (hasSession) {
        final user = await authenticationRepo.getUserData();

        if (user != null) {
          _goTo(Routes.home);
        } else {
          _goTo(Routes.signIn);
        }
      } else {
        _goTo(Routes.signIn);
      }
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
