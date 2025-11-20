import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FsService {
  //MOSTRAR TODOS LOS EVENTOS
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  //MOSTRAR LOS EVENTOS DE UN USUARIO EN CONCRETO
  Stream<QuerySnapshot> eventosPorUsuario(String uid) {
    return FirebaseFirestore.instance
        .collection('eventos')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  //MOSTRAR TODAS LAS CATEGORIAS
  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance
        .collection('categorias')
        .orderBy('nombre')
        .snapshots();
  }

  //MOSTRAR UN EVENTO EN CONCRETO
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

  //AGREGAR
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
      'fecha': Timestamp.fromDate(fecha),
      'lugar': lugar,
      'titulo': titulo,
      'uid': uid,
    });
  }

  //BORRAR
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
