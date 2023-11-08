import 'package:bao24h/services/data/cloud_new.dart';
import 'package:bao24h/utilities/delete_dialog.dart';
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
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        final currentNew = news.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(currentNew);
          },
          title: Text(
            currentNew.title,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(currentNew);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
