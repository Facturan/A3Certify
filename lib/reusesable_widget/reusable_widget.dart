import 'package:flutter/material.dart';

Container elevatedButton(
  BuildContext context,
  String label,
  VoidCallback onTap,
  int red,
  int green,
  int blue,
  TextStyle textStyle,
) {
  return Container(
    height: 55,
    width: 300,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.transparent),
      color: Color.fromARGB(255, red, green, blue),
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: textStyle.copyWith(color: Colors.white),
      ),
    ),
  );
}

Container elevatedButton1(
  BuildContext context,
  String label,
  VoidCallback onTap,
  int red,
  int green,
  int blue,
  TextStyle textStyle,
) {
  return Container(
    height: 60,
    width: 150,
    decoration: BoxDecoration(
      border: Border.all(
          color: const Color.fromARGB(
        255,
        57,
        88,
        134,
      )),
      color: Color.fromARGB(255, red, green, blue),
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: textStyle.copyWith(color: Colors.black),
      ),
    ),
  );
}

GestureDetector elevatedButton3(
  BuildContext context,
  String label,
  VoidCallback onTap,
  int red,
  int green,
  int blue,
  TextStyle textStyle,
  String imagePath,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        color: Color.fromARGB(255, red, green, blue),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 80,
            width: 80,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: textStyle.copyWith(color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  String title1 = 'Are you sure you',
  String title2 = 'want to submit?',
  String confirmText = 'Yes',
  String cancelText = 'No',
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF395886),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 60,
                    color: Color(0xFF395886),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title1,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2C2C),
                  height: 1.2,
                ),
              ),
              Text(
                title2,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2C2C),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF395886),
                        side: const BorderSide(
                          color: Color(0xFF395886),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 24,
                        ),
                        minimumSize: const Size(50, 45),
                      ),
                      child: Text(
                        cancelText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF395886),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: const Color(0xFF395886).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 24,
                        ),
                        minimumSize: const Size(50, 45),
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

GestureDetector elevatedButton4(
  BuildContext context,
  String label,
  VoidCallback onTap,
  int red,
  int green,
  int blue,
  TextStyle textStyle,
  Icon icons,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        color: Color.fromARGB(255, red, green, blue),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
       icons,
          const SizedBox(height: 3),
          Text(
            label,
            style: textStyle.copyWith(color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

