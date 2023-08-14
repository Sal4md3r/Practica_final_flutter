import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app/data/http/http.dart';
import 'app/data/services/constantes.dart';
import 'app/data/services/local/session_service.dart';
import 'app/data/services/remote/account_api.dart';
import 'app/data/services/remote/authentication_api.dart';
import 'app/data/services/remote/internetChecker.dart';
import 'app/data/services/repos_implementation/account_repo_impl.dart';
import 'app/data/services/repos_implementation/authentication_repo_impl.dart';
import 'app/data/services/repos_implementation/conectivity_repo_impl.dart';
import 'app/domain/repositories/account_repository.dart';
import 'app/domain/repositories/autentication_repo.dart';
import 'app/domain/repositories/conectivity_repo.dart';
import 'app/my_app.dart';
import 'app/presentation/global/controllers/session_controller.dart';

void main() {
  final sessionService = SessionService(
    const FlutterSecureStorage(),
  );

  final httpAPI = Http(
    client: http.Client(),
    baseUrl: ConstantesApi.baseUrl,
    apiKey: ConstantesApi.apiKey,
  );
  final accountAPI = AccountAPI(httpAPI);
  runApp(
    MultiProvider(
      providers: [
        Provider<ConectivityRepo>(
          create: (context) {
            return ConectivityRepoImpl(
              Connectivity(),
              InternetChecker(),
            );
          },
        ),
        Provider<AuthenticationRepo>(
          create: (context) {
            return AuthenticationRepoImpl(
              AuthenticationAPI(
                httpAPI,
              ),
              sessionService,
              accountAPI,
            );
          },
        ),
        ChangeNotifierProvider<SessionController>(
          create: (context) => SessionController(
            authenticationRepo: context.read(),
          ),
        ),
        Provider<AccountRepository>(
          create: (context) {
            return AccountRepoImpl(
              accountAPI,
              sessionService,
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// class Injector extends InheritedWidget {
//   const Injector({
//     super.key,
//     required super.child,
//     required this.authenticationRepo,
//   });

//   final AuthenticationRepo authenticationRepo;

//   @override
//   bool updateShouldNotify(_) => false;

//   static Injector of(BuildContext context) {
//     final injector = context.dependOnInheritedWidgetOfExactType<Injector>();

//     assert(injector != null, 'Injector could not found');

//     return injector!;
//   }
// }
