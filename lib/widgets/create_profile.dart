import '../widgets/update_user_profile.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';

Widget createProfileDialog(BuildContext context, MUser curUser) {
  final TextEditingController _displayNameTextController =
      TextEditingController(text: curUser.displayName);
  final TextEditingController _professionTextController =
      TextEditingController(text: curUser.profession);
  final TextEditingController _quoteTextController =
      TextEditingController(text: curUser.quote);
  final TextEditingController _avatarUrlTextController =
      TextEditingController(text: curUser.avatarUrl);

  return UpdateUserProfile(
      user: curUser,
      displayNameTextController: _displayNameTextController,
      professionTextController: _professionTextController,
      quoteTextController: _quoteTextController,
      avatarUrlTextController: _avatarUrlTextController);
}
