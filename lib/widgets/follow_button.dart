import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color buttonColor;
  final String text;
  final Color textColor;
  final Color borderColor;
  const FollowButton({Key? key,
  required this.borderColor,
    required this.buttonColor,
    required this.text,
    this.function,
    required this.textColor

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6.0),
      child: (TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          alignment: Alignment.center,
          height: 27,
          width: MediaQuery.of(context).size.width*0.6,
          child: Text(text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
      )),
    );
  }
}
