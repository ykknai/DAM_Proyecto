import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FsService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance
        .collection('categorias')
        .orderBy('nombre')
        .snapshots();
  }

  Future<Map<String, dynamic>?> eventoId(String id) async {
    final doc = await FirebaseFirestore.instance
        .collection('eventos')
        .doc(id)
        .get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }
    return null;
  }

  Future<void> agregarEvento(
    String autor,
    String categoria,
    DateTime fecha,
    String lugar,
    String titulo,
    String uid,
  ) {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'autor': autor,
      'categoria': categoria,
      'fecha': fecha,
      'lugar': lugar,
      'titulo': titulo,
      'uid': uid,
    });
  }

  Future<bool> borrarEvento(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docRef = FirebaseFirestore.instance.collection('eventos').doc(id);
    final doc = await docRef.get();

    if (doc.exists && doc['uid'] == uid) {
      await docRef.delete();
      return true;
    } else {
      return false;
    }
  }
}
