import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomDismissibleBackground extends HookWidget {
  final Color color;
  final bool isLeft;
  final IconData icon;
  final String text;

  const CustomDismissibleBackground(
      {super.key,
      required this.color,
      required this.isLeft,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Row(
          mainAxisAlignment:
              isLeft ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isLeft)
              const SizedBox(
                width: 20,
              ),
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              text.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
            ),
            if (isLeft)
              const SizedBox(
                width: 20,
              ),
          ],
        ),
      ),
    );
  }
}
