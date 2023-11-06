import 'package:bao24h/services/auth/auth_service.dart';
import 'package:bao24h/view/trangchu_view.dart';
import 'package:flutter/material.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  String get userId => AuthService.firebase().currentUser!.id;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black87.withOpacity(0.60),
        onTap: (value) {
          setState(() {
            currentPageIndex = value;
            debugPrint(value.toString());
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Trang chính",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day_outlined),
            label: "Chọn lịch",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Cá nhân",
          ),
        ],
      ),
      body: <Widget>[
        const TrangChu(),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('Trang chọn lịch'),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Trang cá nhân'),
        ),
      ][currentPageIndex],
    );
  }
}
