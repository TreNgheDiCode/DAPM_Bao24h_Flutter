import 'package:bao24h/constants/routes.dart';
import 'package:bao24h/services/data/cloud_new.dart';
import 'package:flutter/material.dart';

typedef NewCallBack = void Function(CloudNew newNew);

class NewsListView extends StatelessWidget {
  final Iterable<CloudNew> news;
  final NewCallBack onDeleteNote;
  final NewCallBack onTap;
  const NewsListView({
    super.key,
    required this.news,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                height: 50,
                color: Colors.amber,
                child: const Center(child: Text('Entry')),
              );
            },
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(createNewRoute, (route) => false);
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.orange, foregroundColor: Colors.white),
          child: const Text(
            "Tạo báo mới",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
