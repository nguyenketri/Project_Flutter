import 'package:first_app/widgets/custom_color.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Widget screen;
  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    void goToScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    }

    return ElevatedButton(
      onPressed: () {
        goToScreen();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: colorPri,
        backgroundColor: color,
      ),
      child: Text('${text}'),
    );
  }
}
