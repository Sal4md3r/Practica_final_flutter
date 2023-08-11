import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/autentication_repo.dart';
import '../controller/sign_in_controller.dart';
import '../controller/sign_in_state.dart';
import 'widgets/submit_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _username = '', _password = '';
  bool _fetching = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (_) => SignInController(
        const SignInState(),
        authenticationRepository: context.read<AuthenticationRepo>(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: Builder(builder: (context) {
                final controller = Provider.of<SignInController>(context);
                return AbsorbPointer(
                  absorbing: controller.state.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        onChanged: (text) {
                          controller.onUserNameChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Username',
                        ),
                        validator: (text) {
                          text = text?.trim().toLowerCase() ?? '';
                          if (text.isEmpty) {
                            return 'Invalid username';
                          }

                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          controller.onPasswordChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        validator: (text) {
                          text = text?.replaceAll(' ', '') ?? '';
                          if (text.length < 4) {
                            return 'Invalid password';
                          }

                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 40),
                      const SubmitButton(),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
