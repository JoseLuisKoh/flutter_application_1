import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/comment.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
// Importa la clase UserProfile

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;
    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );
    final userMap = user.toMap();

    await _db.collection("Users").doc(uid).set(userMap);
  }

  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserBioInFirebase(String bio) async {
    String uid = AuthService().getCurrenUid();

    try {
      await _db.collection("Users").doc(uid).update({"bio": bio});
    } catch (e) {
      print(e);
    }
  }

  Future<void> postMessageInFirebase(String message) async {
    try {
      String uid = _auth.currentUser!.uid;

      UserProfile? user = await getUserFromFirebase(uid);

      Post newPost = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );
      Map<String, dynamic> newPostMap = newPost.toMap();

      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePostFromFirebase(String posId) async {
    try {
      await _db.collection("Posts").doc(posId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> togglelikeInFirebase(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference postDoc = _db.collection("posts").doc(postId);

      await _db.runTransaction((Transaction) async {
        DocumentSnapshot postSnapshot = await Transaction.get(postDoc);
        List<String> likedBy = List<String>.from(postSnapshot['likedby'] ?? []);

        int currentLikeCount = postSnapshot['likes'];

        if (likedBy.contains(uid)) {
          likedBy.add(uid);
          currentLikeCount++;
        } else {
          likedBy.remove(uid);
          currentLikeCount--;
        }
        Transaction.update(postDoc, {
          'likes': currentLikeCount,
          'likedBy': likedBy,
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> toggleLikeInFirebase(String postId) async {}
  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);
      Comment newComment = Comment(
          id: '',
          postId: postId,
          uid: uid,
          name: user!.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now());

      Map<String, dynamic> newCommentMap = newComment.toMap();
      await _db.collection("Comments").add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCommentIFirebase(String commetI) async {
    try {
      await _db.collection("comments").doc(commetI).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Comments")
          .where("postId", isEqualTo: postId)
          .get();
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
