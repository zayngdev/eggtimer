import 'package:flutter/material.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDialKnob extends StatefulWidget {
  final rotationPercent;

  EggTimerDialKnob({
   this.rotationPercent,
});

  @override
  _EggTimerDialKnobState createState() => _EggTimerDialKnobState();
}

class _EggTimerDialKnobState extends State<EggTimerDialKnob> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: ArrowPainter(
                rotationPercent: widget.rotationPercent
              ),
            ),
          ),
          Container(    // Inner circle
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellowAccent.withOpacity(0.4),
                    blurRadius: 70.0,
                    spreadRadius: 5.0,
                    offset: Offset(0.0, 1.0),
                  )
                ]
            ),

            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      //color: Color(0xFFDFDFDF),
                      color: Colors.yellowAccent.withOpacity(1),
                      width: 0.4
                  )
              ),
              child:  Container(
                margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFDFDFDF),
                          width: 1
                      )
                  ),
                  child:Center(
                    child: Transform(
                      transform: Matrix4.rotationY(2 * 3.14 * widget.rotationPercent),
                      alignment: Alignment.center,
                      child: Icon(Icons.account_circle,
                        color: Colors.grey,),
                    ),
                  ) ,
              ),
            ),
          ),
        ]
    );
  }
}



class ArrowPainter extends CustomPainter {

  final Paint dialArrowPaint;
  final double rotationPercent;

  ArrowPainter({this.rotationPercent})
      : dialArrowPaint = new Paint() {
    dialArrowPaint.color = Colors.red;
    dialArrowPaint.style = PaintingStyle.fill;

  }

  @override
  void paint(Canvas canvas, Size size) {

    canvas.save();

    final radius = size.height / 2;
    canvas.translate(radius, radius);
    canvas.rotate(2 * 3.14 * rotationPercent);

    Path path = new Path();
    path.moveTo(0.0, -radius -10.0);
    path.lineTo(10.0,  -radius + 5.0);
    path.lineTo(-10, -radius + 5);
    path.close();

    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.black, 5.0, false);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


