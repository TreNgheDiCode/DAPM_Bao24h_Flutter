import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/services/data/cloud_new.dart';
import 'package:bao24h/services/data/firebase_cloud_storage.dart';
import 'package:bao24h/view/news/news_list_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
  'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
  'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
  'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
  'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80'
];

final List<Widget> imageSliders = imgList
    .map(
      (item) => Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                ),
              ],
            )),
      ),
    )
    .toList();

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuViewState();
}

class _TrangChuViewState extends State<TrangChu> {
  late final FirebaseCloudStorage _newsService;

  String get userId => AuthService.firebase().currentUser!.id;
  var user = AuthService.firebase().currentUser;

  @override
  void initState() {
    _newsService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Tỗng hợp",
                icon: Icon(Icons.newspaper),
              ),
              Tab(
                text: "Bóng đá",
                icon: Icon(Icons.sports_soccer),
              ),
              Tab(
                text: "Khoa học",
                icon: Icon(Icons.science),
              ),
              Tab(
                text: "Thể thao",
                icon: Icon(Icons.sports),
              ),
            ],
          ),
          toolbarHeight: 0,
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        autoPlayInterval: const Duration(seconds: 3)),
                    items: imageSliders,
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _newsService.allNews(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as Iterable<CloudNew>;
                            return Column(
                              children: [
                                Expanded(
                                  child: NewsListView(
                                    news: allNotes,
                                    onDeleteNote: (currentNew) async {
                                      await _newsService.deleteNote(
                                          documentId: currentNew.documentId);
                                    },
                                    onTap: (currentNew) {
                                      Navigator.of(context).pushNamed(
                                        createNewRoute,
                                        arguments: currentNew,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Text("Không có dữ liệu");
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
            const Center(
              child: Text("Bóng đá"),
            ),
            const Center(
              child: Text("Khoa học"),
            ),
            const Center(
              child: Text("Thể thao"),
            )
          ],
        ),
        floatingActionButton: user?.id != null
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      createNewRoute, (route) => false);
                },
                tooltip: "Thêm báo mới",
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
