import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String notes;
  final String photoUrl;
  final String categories;
  final String publishedDate;
  final String description;
  final int pageCount;
  final String userId;

  Book(
      {this.id,
      this.title,
      this.author,
      this.notes,
      this.photoUrl,
      this.categories,
      this.publishedDate,
      this.description,
      this.pageCount,
      this.userId});

  factory Book.fromDocument(QueryDocumentSnapshot data) {
    Map<String, dynamic> info = data.data();
    return Book(
        id: data.id,
        title: info['title'],
        author: info['author'],
        notes: info['notes'],
        photoUrl: info['photoUrl'],
        categories: info['categories'],
        publishedDate: info['published_date'],
        description: info['description'],
        pageCount: info['page_count'],
        userId: info['user_id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'notes': notes,
      'photoUrl': photoUrl,
      'categories': categories,
      'publishedDate': publishedDate,
      'description': description,
      'pageCount': pageCount,
      'userId': userId
    };
  }
}
