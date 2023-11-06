import 'package:bao24h/utilities/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Xóa bài báo",
    content: "Bạn có chắc chắn? Thao tác này không thể vãn hồi",
    optionsBuilder: () => {
      "Quay về": false,
      "Đồng ý": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
