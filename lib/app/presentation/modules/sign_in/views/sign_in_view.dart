import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/enums.dart';
import '../../../../domain/repositories/autentication_repo.dart';
import '../../../routes/routes.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: AbsorbPointer(
              absorbing: _fetching,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    onChanged: (text) {},
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
                    onChanged: (text) {},
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
                  Builder(builder: (context) {
                    if (_fetching) {
                      return const CircularProgressIndicator();
                    }
                    return MaterialButton(
                      onPressed: () {
                        final isValid = Form.of(context).validate();
                        if (isValid) {
                          _submit(context);
                        }
                      },
                      color: Colors.tealAccent,
                      child: const Text('Sign in'),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _fetching = true;
    });

    final result = await Provider.of<AuthenticationRepo>(
      context,
      listen: false,
    ).signIn(
      _username,
      _password,
    );

    if (!mounted) {
      return;
    }

    result.when((failure) {
      setState(() {
        _fetching = false;
      });

      final message = {
        SignInFailure.notFound: 'Not Found',
        SignInFailure.unauthorized: 'Unautorized',
        SignInFailure.unknown: 'Unknown error',
        SignInFailure.noInternet: 'No network conection'
      }[failure];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message!),
        ),
      );
    }, (user) {
      Navigator.pushReplacementNamed(context, Routes.home);
    });
  }
}
