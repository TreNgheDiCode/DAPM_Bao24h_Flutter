import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/view/forgot_password_view.dart';
import 'package:bao24h/view/landing_view.dart';
import 'package:bao24h/view/login_view.dart';
import 'package:bao24h/view/news/create_new_view.dart';
import 'package:bao24h/view/register_view.dart';
import 'package:bao24h/view/start_view.dart';
import 'package:bao24h/view/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Đọc báo mới 24h',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        startRoute: (context) => StartView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        landingRoute: (context) => const LandingView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        resetPasswordRoute: (context) => const ForgotPasswordView(),
        createNewRoute: (context) => const CreateNewView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return StartView(user: user);
              } else {
                return const VerifyEmailView();
              }
            } else {
              return StartView();
            }
          default:
            return const Scaffold(
              body: Center(
                child: Text("Đang tải thông tin mới nhất"),
              ),
            );
        }
      },
    );
  }
}
