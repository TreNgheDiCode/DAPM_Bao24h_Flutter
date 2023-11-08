import 'dart:convert';

import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/generics/get_arguments.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/services/data/cloud_new.dart';
import 'package:bao24h/services/data/firebase_cloud_storage.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

class CreateNewView extends StatefulWidget {
  const CreateNewView({super.key});

  @override
  State<CreateNewView> createState() => _CreateNewViewState();
}

class _CreateNewViewState extends State<CreateNewView> {
  CloudNew? _new;

  final CloudinaryObject _cloudinaryObject =
      CloudinaryObject.fromCloudName(cloudName: "drv0jpgyx");

  late final FirebaseCloudStorage _newsService;

  late final QuillController _controller;

  late final TextEditingController _title;

  Future<CloudNew> createNew(BuildContext context) async {
    final widgetNew = context.getArgument<CloudNew>();

    if (widgetNew != null) {
      _new = widgetNew;
      var descriptionJSON = jsonDecode(widgetNew.description);
      _controller.document = Document.fromJson(descriptionJSON);
      _title.text = widgetNew.title;
      return widgetNew;
    }

    final existingNew = _new;
    if (existingNew != null) {
      return existingNew;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNew = await _newsService.createNewNew(
        ownerUserId: userId, title: "Báo mới", imgUrl: "test");
    _new = newNew;
    return newNew;
  }

  @override
  void initState() {
    _newsService = FirebaseCloudStorage();
    _controller = QuillController.basic();
    _title = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final currentNew = _new;
    if (currentNew == null) {
      return null;
    }
    final title = _title.text;
    final text = jsonEncode(_controller.document.toDelta().toJson());
    await _newsService.updateNote(
      documentId: currentNew.documentId,
      title: title,
      imgUrl: "test",
      description: text,
    );
  }

  void _deleteNewIfTextIsEmpty() {
    final currentNew = _new;
    if (_controller.document.toPlainText().isEmpty && currentNew != null) {
      _newsService.deleteNote(documentId: currentNew.documentId);
    }
  }

  void _setupTextControllerListener() {
    _title.removeListener(_textControllerListener);
    _controller.removeListener(_textControllerListener);
    _title.addListener(_textControllerListener);
    _controller.addListener(_textControllerListener);
  }

  void _saveNewIfTextNotEmpty() async {
    final currentNew = _new;
    final title = _title.text;
    final description = jsonEncode(_controller.document.toDelta().toJson());
    if (currentNew != null && description.isNotEmpty) {
      await _newsService.updateNote(
        documentId: currentNew.documentId,
        title: title,
        imgUrl: "test",
        description: description,
      );
    }
  }

  @override
  void dispose() {
    _deleteNewIfTextIsEmpty();
    _saveNewIfTextNotEmpty();
    _controller.dispose();
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => {
                  dispose(),
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(landingRoute, (route) => false)
                },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          "Tạo báo mới",
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: createNew(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 500,
                          height: 300,
                          child:
                              CldImageWidget(publicId: "gqe1jc9zhyaxkpeiws4x"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _title,
                          enableSuggestions: true,
                          autocorrect: false,
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(16.0),
                            prefixIcon: Icon(Icons.title_rounded),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.orange),
                            ),
                            hintText: "Nhập tiêu đề bài báo tại đây",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: QuillProvider(
                          configurations: QuillConfigurations(
                            controller: _controller,
                            sharedConfigurations:
                                const QuillSharedConfigurations(
                              locale: Locale("vi"),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              QuillToolbar(
                                configurations:
                                    QuillToolbarConfigurations(customButtons: [
                                  QuillCustomButton(
                                    iconData: Icons.image,
                                    onTap: () async {},
                                  )
                                ]),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: QuillEditor.basic(
                                  configurations:
                                      const QuillEditorConfigurations(
                                    placeholder: "Viết gì đó...",
                                    expands: false,
                                    padding: EdgeInsets.zero,
                                    readOnly: false,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
