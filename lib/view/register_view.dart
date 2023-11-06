import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/extensions/buildcontext/loc.dart';
import 'package:bao24h/services/auth/auth_exceptions.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/utilities/error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _name;
  late final TextEditingController _password;
  late final TextEditingController _rePassword;

  @override
  void initState() {
    _email = TextEditingController();
    _name = TextEditingController();
    _password = TextEditingController();
    _rePassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _password.dispose();
    _rePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
          startRoute,
          (route) => false,
        );
        return false;
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
                      context.loc.register,
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
                          autofocus: true,
                          enableSuggestions: false,
                          autocorrect: false,
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
                            controller: _name,
                            enableSuggestions: true,
                            autocorrect: false,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: const Icon(Icons.person_outline),
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
                              hintText: "Nhập họ tên của bạn",
                            ),
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
                              prefixIcon: const Icon(Icons.key),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 0),
                          child: TextField(
                            controller: _rePassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: const Icon(Icons.key),
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
                              hintText: "Nhập lại mật khẩu của bạn",
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
                          final name = _name.text;
                          final password = _password.text;
                          try {
                            await AuthService.firebase().createUser(
                              email: email,
                              name: name,
                              password: password,
                            );
                            AuthService.firebase().sendEmailVerification();
                            if (!mounted) return;
                            Navigator.of(context).pushNamed(verifyEmailRoute);
                          } on EmailAlreadyInUseAuthException {
                            await showErrorDialog(
                              context,
                              "Địa chỉ email đã được sử dụng",
                            );
                          } on WeakPasswordAuthException {
                            await showErrorDialog(
                              context,
                              'Mật khẩu yếu, vui lòng nhập mật khẩu mới mạnh hơn',
                            );
                          } on InvalidEmailAuthException {
                            await showErrorDialog(
                              context,
                              "Vui lòng nhập một địa chỉ email chính xác",
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              'Lỗi đăng ký',
                            );
                          }
                        },
                        child: Text(
                          context.loc.register,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.loc.register_view_already_registered,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                            child: Text(
                              context.loc.login,
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
