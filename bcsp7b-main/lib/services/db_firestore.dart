import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bcsp7b/models/journal.dart';
import 'package:flutter_bcsp7b/services/db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionJournals = 'journals';

  DbFirestoreService();

  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalDocs = snapshot.docs.map((doc) => Journal.fromDoc(doc)).toList();
      _journalDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
      return _journalDocs;
    });
  }

  Future<Journal> getJournal(String documentID) {
    return _firestore
        .collection(_collectionJournals)
        .doc(documentID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      return Journal.fromDoc(documentSnapshot.data() ?? {});
    });
  }

  Future<bool> addJournal(Journal journal) async {
    try {
      DocumentReference _documentReference =
          await _firestore.collection(_collectionJournals).add({
        'date': journal.date,
        'mood': journal.mood,
        'note': journal.note,
        'uid': journal.uid,
      });
      // ignore: unnecessary_null_comparison
      return _documentReference.id != null;
    } catch (error) {
      print('Error adding journal: $error');
      return false;
    }
  }

  void updateJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .update({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    });
  }

  void updateJournalWithTransaction(Journal journal) async {
    DocumentReference _documentReference = _firestore.collection(_collectionJournals).doc(journal.documentID);
    var journalData = {
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    };
    _firestore.runTransaction((transaction) async {
      await transaction.update(_documentReference, journalData);
    });
  }

  void deleteJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .delete();
  }
}
