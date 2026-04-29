import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final int trimLength;

  const ExpandableTextWidget({
    super.key,
    required this.text,
    this.trimLength = 150,
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool isTextLong = widget.text.length > widget.trimLength;

    String displayText = isExpanded || !isTextLong
        ? widget.text
        : '${widget.text.substring(0, widget.trimLength)}...';

    return GestureDetector(
      onTap: () {
        if (isTextLong) {
          setState(() {
            isExpanded = !isExpanded;
          });
        }
      },
      child: Text.rich(
        TextSpan(
          text: displayText,
          style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
          children: [
            if (isTextLong && !isExpanded)
              const TextSpan(
                text: ' afficher plus',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            if (isTextLong && isExpanded)
              const TextSpan(
                text: ' afficher moins',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
