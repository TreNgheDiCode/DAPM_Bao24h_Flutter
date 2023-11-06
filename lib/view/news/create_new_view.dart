import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/generics/get_arguments.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/services/data/cloud_new.dart';
import 'package:bao24h/services/data/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateNewView extends StatefulWidget {
  const CreateNewView({super.key});

  @override
  State<CreateNewView> createState() => _CreateNewViewState();
}

class _CreateNewViewState extends State<CreateNewView> {
  CloudNew? _new;

  late final FirebaseCloudStorage _newsService;

  final QuillController _controller = QuillController.basic();

  Future<CloudNew> createNew(BuildContext context) async {
    final widgetNew = context.getArgument<CloudNew>();

    if (widgetNew != null) {
      _new = widgetNew;
      _controller.document = widgetNew.description;
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
    super.initState();
  }

  void _textControllerListener() async {
    final currentNew = _new;
    if (currentNew == null) {
      return null;
    }
    final text = _controller.document.toPlainText();
    await _newsService.updateNote(
      documentId: currentNew.documentId,
      title: "Báo mới",
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
    _controller.removeListener(_textControllerListener);
    _controller.addListener(_textControllerListener);
  }

  void _saveNewIfTextNotEmpty() async {
    final currentNew = _new;
    final text = _controller.document.toPlainText();
    if (currentNew != null && text.isNotEmpty) {
      await _newsService.updateNote(
        documentId: currentNew.documentId,
        title: "Báo mới",
        imgUrl: "test",
        description: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNewIfTextIsEmpty();
    _saveNewIfTextNotEmpty();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil(landingRoute, (route) => false),
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
                child: QuillProvider(
                  configurations: QuillConfigurations(
                    controller: _controller,
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale("vi"),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const QuillToolbar(
                        configurations: QuillToolbarConfigurations(),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: QuillEditor.basic(
                            configurations: const QuillEditorConfigurations(
                                placeholder: "Viết gì đó...",
                                autoFocus: true,
                                expands: false,
                                padding: EdgeInsets.zero,
                                readOnly: false),
                            scrollController: ScrollController(),
                          ),
                        ),
                      )
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
