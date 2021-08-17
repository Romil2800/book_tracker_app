import 'package:book_tracker_app/screens/main_screen.dart';
import 'package:book_tracker_app/util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants/constants.dart';
import '../model/book.dart';
import 'package:flutter/material.dart';
import 'input_decoration.dart';
import 'two_sided_rounded_button.dart';

class BookDetailsDialog extends StatefulWidget {
  const BookDetailsDialog({
    Key key,
    @required this.book,
  }) : super(key: key);

  final Book book;

  @override
  _BookDetailsDialogState createState() => _BookDetailsDialogState();
}

class _BookDetailsDialogState extends State<BookDetailsDialog> {
  bool isReadingClicked = false;
  bool isFinishedReadingClicked = false;
  TextEditingController _notesTextController;
  double _rating;
  final _bookCollectionReference =
      FirebaseFirestore.instance.collection('books');

  @override
  void initState() {
    _notesTextController = TextEditingController(text: widget.book.notes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleTextController =
        TextEditingController(text: widget.book.title);
    final TextEditingController _authorTextController =
        TextEditingController(text: widget.book.author);
    final TextEditingController _photoTextController =
        TextEditingController(text: widget.book.photoUrl);
    // final TextEditingController _notesTextController =
    //     TextEditingController(text: widget.book.notes);

    return AlertDialog(
      title: Column(
        children: [
          Row(
            children: [
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.book.photoUrl),
                radius: 40,
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 100),
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                    label: Text('')),
              )
            ],
          ),
          Text(widget.book.author),
        ],
      ),
      content: Form(
          child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _titleTextController,
                  decoration:
                      buildInputDecoration('Book title', 'Flutter Development'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _authorTextController,
                  decoration: buildInputDecoration('Author', 'Jeff A.'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _photoTextController,
                  decoration: buildInputDecoration('Book cover', ''),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextButton.icon(
                onPressed: widget.book.startedReading == null
                    ? () {
                        setState(() {
                          if (isReadingClicked == false) {
                            isReadingClicked = true;
                          } else {
                            isReadingClicked = false;
                          }
                        });
                      }
                    : null,
                icon: Icon(Icons.book_sharp),
                label: (widget.book.startedReading == null)
                    ? (!isReadingClicked)
                        ? Text('Start Reading')
                        : Text(
                            'Started Reading...',
                            style: TextStyle(color: Colors.blueGrey.shade300),
                          )
                    : Text(
                        'Started on: ${formatDate(widget.book.startedReading)}'),
              ),
              TextButton.icon(
                onPressed: widget.book.finishedReading == null
                    ? () {
                        setState(() {
                          if (isFinishedReadingClicked == false) {
                            isFinishedReadingClicked = true;
                          } else {
                            isFinishedReadingClicked = false;
                          }
                        });
                      }
                    : null,
                icon: Icon(Icons.done),
                label: (widget.book.finishedReading == null)
                    ? (!isFinishedReadingClicked)
                        ? Text('Mark as Read')
                        : Text(
                            'Finished Reading!',
                            style: TextStyle(color: Colors.grey),
                          )
                    : Text(
                        'Finished on ${formatDate(widget.book.finishedReading)}'),
              ),
              RatingBar.builder(
                  allowHalfRating: true,
                  initialRating:
                      widget.book.rating != null ? widget.book.rating : 4.5,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                        );
                      case 1:
                        return Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.redAccent,
                        );
                      case 2:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                        );
                      case 3:
                        return Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                        );
                      case 4:
                        return Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                      default:
                        return Container();
                    }
                  },
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _notesTextController,
                  decoration:
                      buildInputDecoration('Your thoughts', 'Enter notes'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TwoSidedRoundedButton(
                    text: 'Update',
                    radius: 12,
                    color: kIconColor,
                    press: () {
                      final userChnagedTitle =
                          widget.book.title != _titleTextController.text;
                      final userChangedAuthor =
                          widget.book.author != _authorTextController.text;
                      final userChangedPhotoUrl =
                          widget.book.photoUrl != _photoTextController.text;
                      final userChangedRating = widget.book.rating != _rating;
                      final userChangedNotes =
                          widget.book.notes != _notesTextController.text;

                      final bookUpdate = userChnagedTitle ||
                          userChangedAuthor ||
                          userChangedPhotoUrl ||
                          userChangedRating ||
                          userChangedNotes;
                      if (bookUpdate) {
                        FirebaseFirestore.instance
                            .collection('books')
                            .doc(widget.book.id)
                            .update(Book(
                              userId: FirebaseAuth.instance.currentUser.uid,
                              title: _titleTextController.text,
                              author: _authorTextController.text,
                              photoUrl: _photoTextController.text,
                              rating: _rating == null
                                  ? widget.book.rating
                                  : _rating,
                              startedReading: isReadingClicked
                                  ? Timestamp.now()
                                  : widget.book.startedReading,
                              finishedReading: isFinishedReadingClicked
                                  ? Timestamp.now()
                                  : widget.book.finishedReading,
                              notes: _notesTextController.text,
                            ).toMap());
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  TwoSidedRoundedButton(
                      text: 'Delete',
                      radius: 12,
                      color: Colors.red,
                      press: () {
                        Widget cancelButton = TextButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );
                        Widget continueButton = TextButton(
                          child: Text("Yes"),
                          onPressed: () {
                            _bookCollectionReference
                                .doc(widget.book.id)
                                .delete();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreenPage()));
                          },
                        );
                        AlertDialog alert = AlertDialog(
                          title: Text("AlertDialog"),
                          content: Text(
                              "Once the book is deleted, you can\'t retrieve it back. Are you sure?"),
                          actions: [
                            cancelButton,
                            continueButton,
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      })
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
