import 'package:flutter/material.dart';

//heading text
class HeadingText extends StatelessWidget {
  const HeadingText(
      {super.key,
      required this.text,
      required this.align,
      required this.color});
  final String text;
  final TextAlign align;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: color),
    );
  }
}

//sub heading text
class SubHeadingText extends StatelessWidget {
  const SubHeadingText({
    super.key,
    required this.text,
    required this.align,
    required this.color,
  });
  final String text;
  final TextAlign align;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: color),
    );
  }
}

//description text
class DescriptionText extends StatelessWidget {
  const DescriptionText(
      {super.key,
      required this.text,
      required this.align,
      required this.color});
  final String text;
  final TextAlign align;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: color),
      textAlign: align,
    );
  }
}