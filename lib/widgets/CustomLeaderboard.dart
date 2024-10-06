import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Participant {
  final String name;
  final int score;

  Participant(this.name, this.score);
}

class HorizontalBarChart extends StatelessWidget {
  final List<Participant> participants;

  const HorizontalBarChart({Key? key, required this.participants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, participants.length * 40.0), // Adjust height as needed
      painter: BarChartPainter(participants, context),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<Participant> participants;
  final BuildContext context;

  BarChartPainter(this.participants, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    num maxScore = participants.isNotEmpty
        ? participants.map((p) => p.score).reduce((a, b) => a > b ? a : b)
        : 1;

    for (int i = 0; i < participants.length; i++) {
      final participant = participants[i];
      const barHeight = 15.0; // Height of each bar
      final xPosition = (participant.score / maxScore) * (size.width - 120); // Calculate width relative to max score
      final yPosition = i * (barHeight + 40); // Space between bars

      // Draw the bar with rounded corners
      paint.color = Colors.blue;
      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(80, yPosition + 12, xPosition, barHeight),
        const Radius.circular(15), // Adjust the radius for rounded corners
      );
      canvas.drawRRect(rRect, paint);

      // Get text color from the current theme
      final textColor = Theme.of(context).brightness== Brightness.dark
          ? Colors.white // For dark mode
          : Colors.black;

      // Draw participant name
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${participant.name.split(' ')[0]}\n${participant.name.split(' ')[1]}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: textColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, yPosition)); // Offset for text position

      final scoreTextPainter = TextPainter(
        text: TextSpan(
          text: participant.score.toString(),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: textColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      scoreTextPainter.layout();
      // Offset the score to the right of the bar
      scoreTextPainter.paint(canvas, Offset(xPosition + 85, yPosition + 8)); // Adjust offset as needed
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
