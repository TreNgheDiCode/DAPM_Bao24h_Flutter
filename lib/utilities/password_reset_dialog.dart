import 'package:bao24h/utilities/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Khôi phục mật khẩu",
    content:
        "Chúng tôi đã gửi một đường dẫn khôi phục mật khẩu cho bạn. Vui lòng kiểm tra hộp thư email để biết thêm thông tin",
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
