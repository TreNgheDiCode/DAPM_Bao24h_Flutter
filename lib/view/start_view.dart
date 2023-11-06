import 'package:bao24h/components/logout_button.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/services/auth/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:bao24h/components/home_button.dart';
import 'package:bao24h/components/login_button.dart';
import 'package:bao24h/components/register_button.dart';

class StartView extends StatefulWidget {
  StartView({super.key, AuthUser? user});

  final user = AuthService.firebase().currentUser;

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1550850395-c17a8e90ad0a?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YmFsbG9vbnN8ZW58MHx8MHx8fDA%3D"),
              opacity: 0.5,
              fit: BoxFit.cover),
        ),
        child: Center(
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                  child: Text(
                    "Bản Tin 24H",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        fontFamily: "Agbalumo"),
                  ),
                ),
                const HomeButton(),
                widget.user != null
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox.shrink(),
                widget.user != null
                    ? const LogoutButton()
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 10,
                ),
                widget.user == null
                    ? const LoginButton()
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 10,
                ),
                widget.user == null
                    ? const RegisterButton()
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
