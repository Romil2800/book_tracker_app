import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import '../model/book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'input_decoration.dart';
import 'search_bool_detail_dialog.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  List<Book> listOfBooks = [];

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Search'),
        backgroundColor: Colors.redAccent,
      ),
      body: Material(
        elevation: 2,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: TextField(
                        onSubmitted: (value) {
                          _search();
                        },
                        controller: _searchTextController,
                        decoration:
                            buildInputDecoration('Search', 'Search books'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                (listOfBooks != null && listOfBooks.isNotEmpty)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 200,
                              width: 300,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: createBookCards(listOfBooks, context),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(''),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search() async {
    await fetchBooks(_searchTextController.text).then((value) {
      setState(() {
        listOfBooks = value;
      });
    }, onError: (val) {
      throw Exception('failed to load books ${val.toString()}');
    });
  }

  Future<List<Book>> fetchBooks(String query) async {
    List<Book> books = [];
    http.Response response = await http
        .get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['items'];
      for (var item in list) {
        //print('${item['volumeInfo']['title']}');

        String title = item['volumeInfo']['title'] == null
            ? 'N/A'
            : item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'][0] == null
            ? 'N/A'
            : item['volumeInfo']['authors'][0];
        String notes = item['volumeInfo']['notes'] == null
            ? 'N/A'
            : item['volumeInfo']['notes'];
        String photoUrl = item['volumeInfo']['imageLinks']['thumbnail'] == null
            ? 'N/A'
            : item['volumeInfo']['imageLinks']['thumbnail'];
        String categories = item['volumeInfo']['categories'] == null
            ? 'N/A'
            : item['volumeInfo']['categories'][0];
        String publishedDate = item['volumeInfo']['publishedDate'] == null
            ? 'N/A'
            : item['volumeInfo']['publishedDate'];
        String description = item['volumeInfo']['description'] == null
            ? 'N/A'
            : item['volumeInfo']['description'];
        int pageCount = item['volumeInfo']['pageCount'] == null
            ? 'N/A'
            : item['volumeInfo']['pageCount'];
        // String userId = item['volumeInfo']['userId'] == null
        //     ? 'N/A'
        //     : item['volumeInfo']['userId'];

        Book searchedBook = new Book(
          title: title,
          author: author,
          notes: notes,
          photoUrl: photoUrl,
          description: description,
          publishedDate: publishedDate,
          pageCount: pageCount,
          categories: categories,
        );

        books.add(searchedBook);
      }
    } else {
      throw ('error ${response.reasonPhrase}');
    }
    return books;
  }

  List<Widget> createBookCards(List<Book> listOfBooks, BuildContext context) {
    final _bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    List<Widget> children = [];
    for (var book in listOfBooks) {
      children.add(
        Container(
          width: 160,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Card(
            elevation: 5,
            color: HexColor('#f6f4ff'),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SearchBookDetailDialog(
                          book: book,
                          bookCollectionReference: _bookCollectionReference);
                    });
              },
              child: Wrap(
                children: [
                  Image.network(
                    (book.photoUrl == null || book.photoUrl.isEmpty)
                        ? 'https://picsum.photos/200/300'
                        : book.photoUrl,
                    height: 100,
                    width: 160,
                  ),
                  ListTile(
                    title: Text(
                      book.title,
                      style: TextStyle(color: HexColor('#5d48b6')),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      book.author,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return children;
  }
}
