import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';
import 'package:flutter/material.dart';
import 'input_decoration.dart';

class UpdateUserProfile extends StatelessWidget {
  const UpdateUserProfile({
    Key key,
    @required TextEditingController displayNameTextController,
    @required TextEditingController professionTextController,
    @required TextEditingController quoteTextController,
    @required TextEditingController avatarUrlTextController,
    this.user,
  })  : _displayNameTextController = displayNameTextController,
        _professionTextController = professionTextController,
        _quoteTextController = quoteTextController,
        _avatarUrlTextController = avatarUrlTextController,
        super(key: key);

  final MUser user;
  final TextEditingController _displayNameTextController;
  final TextEditingController _professionTextController;
  final TextEditingController _quoteTextController;
  final TextEditingController _avatarUrlTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('Edit ${user.displayName}'),
      ),
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(user.avatarUrl != null
                      ? user.avatarUrl
                      : 'https://picsum.photos/200/300'),
                  radius: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _displayNameTextController,
                  decoration: buildInputDecoration('Your Name', ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _professionTextController,
                  decoration: buildInputDecoration('Profession', ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _quoteTextController,
                  decoration: buildInputDecoration('Favorite quote', ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _avatarUrlTextController,
                  decoration: buildInputDecoration('Avatar Url', ''),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              final userChangedName =
                  user.displayName != _displayNameTextController.text;
              final userChangedProfession =
                  user.profession != _professionTextController.text;
              final userChangedquote = user.quote != _quoteTextController.text;
              final userChangedAvatarUrl =
                  user.avatarUrl != _avatarUrlTextController.text;

              final userNeedUpdate = userChangedName ||
                  userChangedquote ||
                  userChangedProfession ||
                  userChangedAvatarUrl;

              if (userNeedUpdate) {
                print("updating...");
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.id)
                    .update(MUser(
                      uid: user.uid,
                      displayName: _displayNameTextController.text,
                      avatarUrl: _avatarUrlTextController.text,
                      quote: _quoteTextController.text,
                      profession: _professionTextController.text,
                    ).toMap());
              }

              Navigator.of(context).pop();
            },
            child: Text('Update'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ),
      ],
    );
  }
}
