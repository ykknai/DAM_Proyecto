import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      // Iniciar sesión
      final GoogleSignInAccount? usuarioGoogle = await _googleSignIn.signIn();
      if (usuarioGoogle == null) return null;

      // Atenticación
      final GoogleSignInAuthentication autenticacionGoogle =
          await usuarioGoogle.authentication;

      // Crea las credenciales de Firebase
      final OAuthCredential credenciales = GoogleAuthProvider.credential(
        accessToken: autenticacionGoogle.accessToken,
        idToken: autenticacionGoogle.idToken,
      );

      // Inicia sesión en Firebase
      final UserCredential credencialesUsuario = await _auth
          .signInWithCredential(credenciales);

      return credencialesUsuario.user;
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
