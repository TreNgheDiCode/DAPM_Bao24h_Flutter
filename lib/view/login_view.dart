import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/extensions/buildcontext/loc.dart';
import 'package:bao24h/services/auth/auth_exceptions.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/utilities/error_dialog.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          startRoute,
          (route) => false,
        );
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1550850395-c17a8e90ad0a?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YmFsbG9vbnN8ZW58MHx8MHx8fDA%3D"),
                opacity: 0.5,
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      context.loc.login,
                      style: const TextStyle(
                          fontFamily: "Agbalumo",
                          color: Colors.orange,
                          fontSize: 48,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _email,
                          enableSuggestions: false,
                          autocorrect: false,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            prefixIcon: const Icon(Icons.email_outlined),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.orange),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: context.loc.email_text_field_placeholder,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 0),
                          child: TextField(
                            controller: _password,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: const Icon(Icons.key_outlined),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.black),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.orange),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              hintText:
                                  context.loc.password_text_field_placeholder,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: const Size(150, 56),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            await AuthService.firebase().logIn(
                              email: email,
                              password: password,
                            );
                            final user = AuthService.firebase().currentUser;
                            if (user?.isEmailVerified ?? false) {
                              // user's email is verified
                              if (!context.mounted) return;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                landingRoute,
                                (route) => false,
                              );
                            } else {
                              // user's email is not verified
                              if (!context.mounted) return;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                verifyEmailRoute,
                                (route) => false,
                              );
                            }
                          } on UserNotFoundAuthException {
                            await showErrorDialog(
                              context,
                              'Người dùng không tồn tại trong hệ thống',
                            );
                          } on WrongPasswordAuthException {
                            await showErrorDialog(
                              context,
                              'Sai tài khoản hoặc mật khẩu',
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              'Lỗi đăng nhập',
                            );
                          }
                        },
                        child: Text(
                          context.loc.login,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          resetPasswordRoute,
                          (route) => false,
                        );
                      },
                      child: Text(
                        context.loc.forgot_password,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.loc.login_view_not_registered_yet,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                            child: Text(
                              context.loc.register,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
