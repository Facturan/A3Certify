import 'package:a3certify/screens/components/constants.dart';
import 'package:a3certify/settingnav/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final Setting setting;
  const SettingTile({
    super.key,
    required this.setting,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (setting.route != null && setting.route!.isNotEmpty) {
          Navigator.pushNamed(context, setting.route!);
        } else {
          setting.onTap?.call();
        }
      },
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: klightContentColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(setting.icon, color: kprimaryColor),
          ),
          const SizedBox(width: 10),
          Text(
            setting.title,
            style: const TextStyle(
              color: kprimaryColor,
              fontSize: ksmallFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Icon(
            CupertinoIcons.chevron_forward,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}