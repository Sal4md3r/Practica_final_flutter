import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/controllers/session_controller.dart';
import '../../../routes/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    final user = sessionController.state!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.id.toString()),
            Text(user.username),
            TextButton(
              onPressed: () {
                sessionController.signOut();
                Navigator.pushReplacementNamed(context, Routes.signIn);
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
