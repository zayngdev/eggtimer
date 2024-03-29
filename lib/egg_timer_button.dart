import 'package:flutter/material.dart';

class EggTimerButton extends StatelessWidget {

  final IconData icon;
  final String text;
  final void Function() onPressed;


  EggTimerButton({
    this.icon,
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Color(0x22000000),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right:3.0),
              child: Icon(icon,
                color: Colors.black,),
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: "SourceHans",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0
              ),
            )
          ],
        ),
      ),
    );
  }
}
