import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../app/helper/helper_functions.dart';
import '/app/errors/exception.dart';
import '/app/utils/constants_manager.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../models/user_model.dart';

abstract class BaseAuthRemoteDataSource {
  Future<UserModel> signIn(LoginInputs userInputs);
  Future<UserModel> signUp(SignUpInputs userInputs);
  Future<bool> forgetPassord(String email);
  Future<UserModel> signInWithCredential(AuthCredential authCredential);
  Future<AuthCredential> facebook();
  Future<AuthCredential> twitter();
  Future<AuthCredential> google();
  Future<void> logout(String uid);
  Future<void> delete(UserModel userModel);
}

class AuthRemoteDataSource implements BaseAuthRemoteDataSource {
  final FirebaseMessaging firebaseMessaging;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FacebookAuth facebookAuth;
  final TwitterLogin twitterLogin;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSource(
    this.firebaseMessaging,
    this.firebaseFirestore,
    this.firebaseAuth,
    this.facebookAuth,
    this.twitterLogin,
    this.googleSignIn,
  );

  @override
  Future<UserModel> signIn(LoginInputs userInputs) async {
    try {
      final UserCredential userCredential = await _signInWithEmailAndPassword(
        email: userInputs.email,
        password: userInputs.password,
      );
      final UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? AppConstants.emptyVal,
        email: userInputs.email,
        password: HelperFunctions.encrptPassword(userInputs.password),
        pic: userCredential.user!.photoURL ?? AppConstants.emptyVal,
        deviceToken: await getDeviceToken(),
      );
      return _uploadDataToFireStore(userModel);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<UserModel> signUp(SignUpInputs userInputs) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: userInputs.email,
        password: userInputs.password,
      );
      final UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: userInputs.name,
        email: userInputs.email,
        password: HelperFunctions.encrptPassword(userInputs.password),
        pic: userCredential.user!.photoURL ?? AppConstants.emptyVal,
        deviceToken: await getDeviceToken(),
      );
      return _uploadDataToFireStore(userModel);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<bool> forgetPassord(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<AuthCredential> facebook() async {
    try {
      final LoginResult loginResult = await facebookAuth.login();
      final String accessToken = loginResult.accessToken!.token;
      final OAuthCredential faceCredential =
          FacebookAuthProvider.credential(accessToken);
      return faceCredential;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<AuthCredential> twitter() async {
    try {
      final AuthResult authResult = await twitterLogin.login();
      final OAuthCredential twitterCredential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!);
      return twitterCredential;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<AuthCredential> google() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        return googleCredential;
      } else {
        throw ServerExecption(AppConstants.nullError);
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<void> logout(String uid) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _getUserDataFromFireStore(uid);
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        Map<String, dynamic> map = doc.data();
        map['deviceToken'] = '';
        firebaseFirestore
            .collection(AppConstants.usersCollection)
            .doc(doc.id)
            .update(map);
      }
      return await firebaseAuth.signOut();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<void> delete(UserModel userModel) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _getUserDataFromFireStore(userModel.id);
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        firebaseFirestore
            .collection(AppConstants.usersCollection)
            .doc(doc.id)
            .delete();
      }
      final UserCredential userCredential = await _signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password!,
      );
      return await userCredential.user!.delete();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithCredential(AuthCredential authCredential) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(authCredential);
      final User? user = userCredential.user;
      final UserModel userModel = UserModel(
        id: user == null ? AppConstants.emptyVal : user.uid,
        name: user == null
            ? AppConstants.emptyVal
            : user.displayName ?? AppConstants.emptyVal,
        email: user == null
            ? AppConstants.emptyVal
            : user.email ?? AppConstants.emptyVal,
        pic: user == null
            ? AppConstants.emptyVal
            : user.photoURL ?? AppConstants.emptyVal,
        deviceToken: await getDeviceToken(),
      );
      return _uploadDataToFireStore(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == AppConstants.differentCredential) {
        return _link(e.credential!);
      } else {
        throw ServerExecption(e.message.toString());
      }
    }
  }

  Future<UserCredential> _signInWithEmailAndPassword(
          {required String email, required String password}) =>
      firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<QuerySnapshot<Map<String, dynamic>>> _getUserDataFromFireStore(
          String uid) =>
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .where(AppConstants.userIdFeild, isEqualTo: uid)
          .get();

  Future<UserModel> _uploadDataToFireStore(UserModel userModel) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _getUserDataFromFireStore(userModel.id);
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      var tempUser = userModel.copyWith(
        name: userModel.name.isEmpty ? doc.data()['name'] : userModel.name,
        pic: userModel.pic ?? doc.data()['pic'],
      );
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .doc(doc.id)
          .update(tempUser.toJson());
      return tempUser;
    } else {
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .add(userModel.toJson());
      return userModel;
    }
  }

  Future<UserModel> _link(AuthCredential authCredential) async {
    final UserCredential? userCredential =
        await firebaseAuth.currentUser?.linkWithCredential(authCredential);
    if (userCredential != null) {
      final User? user = userCredential.user;
      final UserModel userModel = UserModel(
        id: user == null ? AppConstants.emptyVal : user.uid,
        name: user == null
            ? AppConstants.emptyVal
            : user.displayName ?? AppConstants.emptyVal,
        email: user == null
            ? AppConstants.emptyVal
            : user.email ?? AppConstants.emptyVal,
        pic: user == null
            ? AppConstants.emptyVal
            : user.photoURL ?? AppConstants.emptyVal,
        deviceToken: await getDeviceToken(),
      );
      _uploadDataToFireStore(userModel);
      return userModel;
    } else {
      throw ServerExecption(AppConstants.tryAgain);
    }
  }

  Future<String> getDeviceToken() async {
    String? value = await firebaseMessaging.getToken();
    return value ?? '';
  }
}
