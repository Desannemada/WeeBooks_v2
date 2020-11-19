import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/models/user.dart';
import 'package:weebooks2/ui/telas/home/home.dart';
import 'package:weebooks2/ui/telas/menuInicial/menuInicial.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //objeto usuario
  Usuario _userFromFirebaseUser(User usuario) {
    return usuario != null
        ? Usuario(
            uid: usuario.uid,
            displayName: usuario.displayName,
            email: usuario.email,
            emailVerified: usuario.emailVerified,
            photoURL: usuario.photoURL,
          )
        : null;
  }

  //user info
  Usuario getUserInfo() {
    final User usuario = _auth.currentUser;
    return usuario != null
        ? Usuario(
            uid: usuario.uid,
            displayName: usuario.displayName,
            email: usuario.email,
            emailVerified: usuario.emailVerified,
            photoURL: usuario.photoURL,
          )
        : null;
  }

  //auth stream de usuario
  Stream<Usuario> get usuario {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //login
  Future loginEmailSenha(String email, String senha) async {
    try {
      UserCredential resultado =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      User usuario = resultado.user;
      return [_userFromFirebaseUser(usuario)];
    } catch (e) {
      print('LOGIN_EMAIL_SENHA: ' + e.toString());
      return [null, e.message];
    }
  }

  //cadastro
  Future cadastroEmailSenha(String email, String senha) async {
    try {
      UserCredential resultado = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      User usuario = resultado.user;
      return [_userFromFirebaseUser(usuario)];
    } catch (e) {
      print('CADASTRO_EMAIL_SENHA: ' + e.toString());
      return [null, e.message];
    }
  }

  //logout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('SIGN_OUT: ' + e.toString());
      return null;
    }
  }

  //delete user
  Future deletarUsuario() {
    try {
      return _auth.currentUser.delete();
    } catch (e) {
      print('DELETAR_USUARIO: ' + e.toString());
      return null;
    }
  }

  //verify email
  Future sendEmailVerification() async {
    try {
      await _auth.currentUser.sendEmailVerification();
      return true;
    } catch (e) {
      print("EMAIL_VERIFICACAO: " + e.toString());
      return false;
    }
  }

  //reset password
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("RESET_PASSWORD: " + e.toString());
      return false;
    }
  }
}

final homeKey = GlobalKey<HomeState>();

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario>(context);

    if (usuario == null) {
      return MenuInicial();
    } else {
      return Home(key: homeKey);
    }
  }
}
