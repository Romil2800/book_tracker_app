import '../widgets/two_sided_rounded_button.dart';
import '../constants/constants.dart';
import '../model/book.dart';
import 'package:flutter/material.dart';

import 'book_rating.dart';

class ReadingListCard extends StatelessWidget {
  final String image;
  final String title;
  final String author;
  final double rating;
  final String buttonText;
  final Book book;
  final bool isBookRead;
  final Function pressDetails;
  final Function pressRead;

  const ReadingListCard({
    Key key,
    this.image,
    this.title,
    this.author,
    this.rating = 4.5,
    this.buttonText,
    this.book,
    this.isBookRead,
    this.pressDetails,
    this.pressRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 202,
        margin: EdgeInsets.only(
          left: 24,
          bottom: 0,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 244,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 33,
                      color: kShadowColor,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                image,
                width: 100,
              ),
            ),
            Positioned(
              top: 34,
              right: 10,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  BookRating(score: (rating)),
                ],
              ),
            ),
            Positioned(
              top: 150,
              child: Container(
                height: 95,
                width: 202,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 24),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: kBlackColor),
                          children: [
                            TextSpan(
                              text: '$title\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: author,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: Text('Details'),
                        ),
                        Expanded(
                          child: TwoSidedRoundedButton(
                            text: buttonText,
                            press: pressRead,
                            color: kLightPurple,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
