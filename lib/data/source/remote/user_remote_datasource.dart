import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract class UserRemoteDataSource {
  Future<User> signInWithGoogle();

  Future<void> signInWithCredentials(String email, String password);

  Future<String> signUp(String email, String password);

  Future<void> signOut();

  Future<bool> isSignedIn();

  Future<User> getUser();

  Future<void> updateUserInfo(String displayName, String photoUrl);
}

@Singleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  UserRemoteDataSourceImpl(
    this.firebaseAuth,
    this.googleSignIn,
  );

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    return firebaseAuth.currentUser;
  }

  Future<void> signInWithCredentials(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String> signUp(String email, String password) async {
    final _auth = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _auth.user.uid;
  }

  Future<void> signOut() async {
    return Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getUser() async {
    return firebaseAuth.currentUser;
  }

  Future<void> updateUserInfo(String displayName, String photoUrl) async {
    final _user = firebaseAuth.currentUser;
    return await _user.updateProfile(
      displayName: displayName,
      photoURL: photoUrl,
    );
  }
}
