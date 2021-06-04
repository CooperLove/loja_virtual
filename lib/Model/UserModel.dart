import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  UserModel() {
    init();
  }

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  void init() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _loadCurrentUser();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  FirebaseAuth _auth;
  User user;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    if (_auth == null) _auth = FirebaseAuth.instance;
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: password)
        .then((user) {
      this.user = user.user;
      _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  bool isLoggedIn() => user != null;

  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      this.user = user.user;
      await _loadCurrentUser();
      isLoading = false;
      notifyListeners();
      onSuccess();
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
      onFail();
    });
  }

  void signOut() {
    if (_auth == null) _auth = FirebaseAuth.instance;
    _auth.signOut();

    userData = Map();
    user = null;
    notifyListeners();
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (user == null) user = _auth?.currentUser;
    if (user != null && userData["name"] == null) {
      DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      userData = docUser.data();
    }
    notifyListeners();
  }

  void recoverPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }
}
