import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        title: const Text("Xác thực email"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                  "Chúng tôi đã gửi một đường dẫn xác thực email tới hòm thư của bạn. Vui lòng xác thực email để tiếp tục sử dụng. Trong trường hợp không nhận được email, nhấn nút gửi lại bên dưới!"),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                child: const Text("Gửi đường dẫn xác thực email"),
              ),
              TextButton(
                onPressed: () async {
                  if (!mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                  await AuthService.firebase().logOut();
                },
                child: const Text("Quay về trang đăng nhập"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
