import 'package:bao24h/services/data/cloud_new.dart';
import 'package:bao24h/services/data/cloud_storage_constants.dart';
import 'package:bao24h/services/data/cloud_storage_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorage {
  final news = FirebaseFirestore.instance.collection('news');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await news.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String title,
    required String imgUrl,
    required String description,
  }) async {
    try {
      await news.doc(documentId).update({
        titleFieldName: title,
        imgUrlFieldName: imgUrl,
        descriptionFieldName: description,
        updatedAtFieldName: DateTime.now()
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNew>> allNews() => news
      .snapshots()
      .map((event) => event.docs.map((doc) => CloudNew.fromSnapshot(doc)));

  Future<CloudNew> createNewNew(
      {required String ownerUserId,
      required String title,
      required String imgUrl}) async {
    final document = await news.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: title,
      imgUrlFieldName: imgUrl,
      descriptionFieldName: '',
      createdAtFieldName: Timestamp.now(),
      updatedAtFieldName: Timestamp.now()
    });

    final fetchedNote = await document.get();
    return CloudNew(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      title: title,
      imgUrl: imgUrl,
      description: '',
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
