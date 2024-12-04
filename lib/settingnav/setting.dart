import 'package:a3certify/settingnav/logout_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final String? route;

  Setting({
    required this.title,
    required this.icon,
    this.onTap,
    this.route,
  });

  String? get settingRoute => route;

}

final List<Setting> settings = [
  Setting(
    title: "Personal Data",
    icon: CupertinoIcons.person_fill,
    onTap: () => Navigator.pushNamed(navigatorKey.currentContext!, '/personaldata'),
  ),
  Setting(
    title: "Password",
    icon: Icons.lock,
    route: '/',
  ),
  Setting(
    title: "Contact Us",
    icon: CupertinoIcons.phone_fill,
    route: '/',
  ),
];

final List<Setting> settings2 = [
  Setting(
    title: "FAQ",
    icon: CupertinoIcons.ellipsis_vertical_circle_fill,
    route: '/',
  ),
  Setting(
    title: "Terms and Conditions",
    icon: CupertinoIcons.doc_fill,
    route: '/',
  ),
  Setting(
    title: "Logout",
    icon: Icons.logout,
    onTap: () {
      if (navigatorKey.currentContext != null) {
        showLogoutConfirmationDialog(navigatorKey.currentContext!);
      }
    },
  ),
];
