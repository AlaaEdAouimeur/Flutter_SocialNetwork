import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseReferences {
  CollectionReference posts,
      users, category, categoryPosts, followers, followings, likes, blogs;
  Firestore firestore;

  DatabaseReferences() {
    firestore = Firestore.instance;
    posts = firestore.collection('posts');
    blogs = firestore.collection('blogs');
    users = firestore.collection('users');
    category = firestore.collection('categories');
    categoryPosts = firestore.collection('category_posts');
    followers = firestore.collection('followers');
    followings = firestore.collection('followings');
    likes = firestore.collection('likes');
  }

}