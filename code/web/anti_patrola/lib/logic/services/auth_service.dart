import 'package:anti_patrola/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  final GoogleSignIn _googleSignIn;
  static const String _ACCESS_TOKEN_TAG = 'accessToken';
  UserModel _currentUser;
  AuthService({GoogleSignIn googleSignIn}): 
    _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']);

  /// Get the current logged in used
  /// If no user is logged in returns NULL
  UserModel get currentUser => _currentUser;

  /// Logs in user with a google account and saves a token
  /// If login was sucessful returns true
  /// If something goes wrong returns false
  Future<bool> signInWithGoogle() async {
    // TODO: Check for cached token first
    try{
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      _currentUser = _userModelFromGoogleUser(googleUser);
      final googleAuth = await googleUser.authentication;
      _saveToken(googleAuth.idToken);
      return true;
    } catch (e){
      debugPrint(e.toString());
      return false;
    }
  }

  /// Signs out user and deletes token from cache
  Future<bool> signOut() async {
    _currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_ACCESS_TOKEN_TAG);
  }

  Future<bool> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_ACCESS_TOKEN_TAG, token);
  }

  /// Returns token String if one exists, otherwise returns NULL
  Future<String> readToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ACCESS_TOKEN_TAG);
  }

  UserModel _userModelFromGoogleUser(GoogleSignInAccount user){
    return UserModel(
      uuid: user.id, 
      username: user.displayName, 
      email: user.email,
    );
  }
}