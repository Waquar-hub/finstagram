import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final String USER_COLLECTION = "users";
final String POSTS_COLLECTION = 'posts';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Map? currentUser;
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required File image,
  }) async {
    try {
      UserCredential _userCredetial = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String _userId = _userCredetial.user!.uid;
      // saving file on firebase cloud.Here p.extension gives the file at the last for example .jpg,.png,etc
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image.path); //'348643789'.png
      UploadTask _uploadeImageTask = _storage
          .ref("images/$_userId/$_fileName")
          .putFile(
              image); //images/XGRR13677/3467754568.png.putfile function is used to put the image on firebase cloud.
      return _uploadeImageTask.then((_snapshot) async {
        String _downlodUrl = await _snapshot.ref.getDownloadURL();
        await _db.collection(USER_COLLECTION).doc(_userId).set({
          'name': name,
          'email': email,
          'password': password,
          'image': _downlodUrl,
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  FirebaseService();
// function for put the data on fire base using log in
  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      //go to fire base and authenticate the user and log the user.
      UserCredential _userCredencial = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //it receives the data from cloud firestore.
      if (_userCredencial.user != null) {
        currentUser = await getUserData(uid: _userCredencial.user!.uid);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // function to get the data from the firebase data base
  Future<Map> getUserData({
    required String uid,
  }) async {
    DocumentSnapshot _docs =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    return _docs.data() as Map;
  }

  Future<bool> postImage(File _image) async {
    try {
      String _userId = _auth.currentUser!.uid;
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(_image.path);
      UploadTask _task =
          _storage.ref('images/$_userId/$_fileName').putFile(_image);
      return await _task.then((_snapshot) async {
        String _downloadURL = await _snapshot.ref.getDownloadURL();
        await _db.collection(POSTS_COLLECTION).add({
          'userId': _userId,
          'timestamp': Timestamp.now(),
          'image': _downloadURL
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> getLatestPost() {
    return _db
        .collection(POSTS_COLLECTION)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
