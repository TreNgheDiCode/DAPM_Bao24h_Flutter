import 'package:bao24h/utilities/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: "Lỗi bất ngờ đã xảy ra",
    content: text,
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
