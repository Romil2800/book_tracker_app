import '../screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: HexColor('#f5f6f8'),
        child: Column(
          children: [
            Spacer(),
            Text(
              'Book Tracker',
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              ' "Read Change Yourself" ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black26,
                fontSize: 29,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: HexColor('#69639f'),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
              icon: Icon(Icons.login_rounded),
              label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Sign in to get started')),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
