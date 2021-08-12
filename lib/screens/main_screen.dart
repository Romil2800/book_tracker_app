import 'package:book_tracker_app/constants/constants.dart';
import 'package:book_tracker_app/model/book.dart';
import '../widgets/reading_list_card.dart';
import '../widgets/book_search.dart';
import '../widgets/create_profile.dart';
import 'package:hexcolor/hexcolor.dart';
import '../screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference usersCollectionReference =
        FirebaseFirestore.instance.collection('users');
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0.0,
        toolbarHeight: 77,
        centerTitle: false,
        title: Row(
          children: [
            Text(
              'A.Reader',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: usersCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'Data is not available',
                    style: TextStyle(color: Colors.black12),
                  ),
                );
              }

              final userListStream = snapshot.data.docs.map((users) {
                return MUser.fromDocuments(users);
              }).where((user) {
                return (user.uid == FirebaseAuth.instance.currentUser.uid);
              }).toList();

              MUser curUser = userListStream[0];

              return Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(curUser.avatarUrl != null
                            ? curUser.avatarUrl
                            : 'https://picsum.photos/200/300'),
                        backgroundColor: Colors.white,
                        child: Text(''),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(curUser
                                                      .avatarUrl !=
                                                  null
                                              ? curUser.avatarUrl
                                              : 'https://picsum.photos/200/300'),
                                          radius: 50,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Books Read',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(color: Colors.redAccent),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            curUser.displayName.toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return createProfileDialog(
                                                    context, curUser);
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.mode_edit,
                                            color: Colors.black,
                                          ),
                                          label: Text(''),
                                        )
                                      ],
                                    ),
                                    Text(
                                      curUser.profession,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 2,
                                      child: Container(
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.blueGrey.shade100,
                                        ),
                                        color: HexColor('#f1f3f5'),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Favorite Quote: ',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              height: 2,
                                              child: Container(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  curUser.quote == null
                                                      ? 'Favorite book quote : Life is great...'
                                                      : "\"${curUser.quote}\"",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                            });
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      curUser.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              );
            },
          ),
          TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                });
              },
              icon: Icon(Icons.logout),
              label: Text('')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookSearchPage(),
              ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, left: 12, bottom: 10),
            width: double.infinity,
            child: Container(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headline5,
                  children: [
                    TextSpan(text: 'Your reading\nactivity'),
                    TextSpan(
                      text: ' right now...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              var userBookFilteredReadListStream =
                  snapshot.data.docs.map((book) {
                return Book.fromDocument(book);
              }).toList();
              return Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userBookFilteredReadListStream.length,
                  itemBuilder: (context, index) {
                    Book book = userBookFilteredReadListStream[index];
                    return ReadingListCard(
                      rating: 5.0,
                      buttonText: 'Reading',
                      image: book.photoUrl != null
                          ? book.photoUrl
                          : 'http://books.google.com/books/content?id=RvcRAQAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api',
                      title: book.title,
                      author: book.author,
                    );
                  },
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Reading List',
                          style: TextStyle(
                            color: kBlackColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              var readingListBook = snapshot.data.docs.map((book) {
                return Book.fromDocument(book);
              }).toList();
              return Expanded(
                flex: 1,
                child: (readingListBook.length > 0)
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: readingListBook.length,
                        itemBuilder: (context, index) {
                          Book book = readingListBook[index];

                          return ReadingListCard(
                            buttonText: 'Not Started',
                            rating: 4.3,
                            author: book.author,
                            image: book.photoUrl,
                            title: book.title,
                          );
                        },
                      )
                    : Center(
                        child: Text(
                        'No books found. Add a book',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
              );
            },
          )
        ],
      ),
    );
  }
}
