import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/services/auth/auth_exceptions.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/utilities/error_dialog.dart';
import 'package:bao24h/utilities/password_reset_dialog.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

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
        title: const Text("Quên mật khẩu"),
        backgroundColor: Colors.blue,
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          Navigator.of(context).pushNamedAndRemoveUntil(
            startRoute,
            (route) => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                    "Trong trường hợp bạn không nhớ mật khẩu cho tài khoản của mình, hãy cung cấp chúng tôi địa chỉ email chính xác để chúng tôi cung cấp đường dẫn khôi phục mật khẩu"),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  decoration: const InputDecoration(
                      hintText: "Nhập email của bạn tại đây"),
                ),
                TextButton(
                  onPressed: () async {
                    final email = _controller.text;
                    try {
                      await AuthService.firebase()
                          .sendPasswordReset(toEmail: email);

                      _controller.clear();
                      if (!context.mounted) return;
                      await showPasswordResetSentDialog(context);
                    } on UserNotFoundAuthException {
                      if (!mounted) return;
                      await showErrorDialog(
                        context,
                        "Không thể thực hiện yêu cầu. Vui lòng xác nhận rằng bạn đã đăng ký, nếu chưa, vui lòng đăng ký một tài khoản mới",
                      );
                    }
                  },
                  child: const Text("Gửi lại đường dẫn khôi phục"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  child: const Text("Quay về trang đăng nhập"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
