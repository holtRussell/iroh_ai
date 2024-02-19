import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatResponseBlock extends StatelessWidget {
  final String inputText;
  final bool isResponse;
  const ChatResponseBlock(
      {required this.inputText, required this.isResponse, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isResponse ? Colors.white.withOpacity(0.15) : Colors.transparent,
      ),
      child: Text(
        inputText,
        style: GoogleFonts.permanentMarker(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
