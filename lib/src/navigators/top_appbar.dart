import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      titleTextStyle: AppTheme.appbarTextStyle,
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const ImageIcon(
          AssetImage('assets/images/icon_arrow_left.png'),
          size: 45,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
