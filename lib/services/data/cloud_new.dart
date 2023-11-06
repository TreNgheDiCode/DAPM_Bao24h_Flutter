import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'cloud_storage_constants.dart';

@immutable
class CloudNew {
  final String documentId;
  final String title;
  final String imgUrl;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String ownerUserId;
  final String description;

  const CloudNew({
    required this.documentId,
    required this.title,
    required this.imgUrl,
    required this.updatedAt,
    required this.createdAt,
    required this.ownerUserId,
    required this.description,
  });

  CloudNew.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
        title = snapshot.data()[titleFieldName] as String,
        imgUrl = snapshot.data()[imgUrlFieldName] as String,
        createdAt = snapshot.data()[createdAtFieldName] as Timestamp,
        updatedAt = snapshot.data()[updatedAtFieldName] as Timestamp,
        description = snapshot.data()[descriptionFieldName] as String;
}
