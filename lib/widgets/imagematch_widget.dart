import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:ispy/paint/eye_painter.dart';

class ImageMatchWidget extends StatelessWidget {
  final SpiedModel spiedModel;

  ImageMatchWidget({
    this.spiedModel,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey _keyCameraPreview = GlobalKey();

    return new Container(


        child:
          Stack(

              alignment: FractionalOffset.center, children: <Widget>[
            RotatedBox(
              quarterTurns: 1,
              child: new AspectRatio(
                  key: _keyCameraPreview,
                  aspectRatio: 1,
                  child:
                  ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child:
                  Image(

                    image: MemoryImage(spiedModel.finalImage),
                    fit: BoxFit.contain,
                  ))),
            ),
            Positioned.fill(
                child: new CustomPaint(
              painter: ProfileCardPainter(spiedModel),
            )),
          ])
        );
/*    return  RotatedBox(quarterTurns: 1, child: Stack(children: <Widget>[


    SizedBox.expand(
     child:Image.memory(spiedModel.finalImage)
    ),

      CustomPaint(
        size: Size.infinite,
        painter: ProfileCardPainter(spiedModel),
      ),

    ]));*/
  }
}

class ProfileCardPainter extends CustomPainter {
  SpiedModel spiedModel;
  ProfileCardPainter(this.spiedModel);

//3
  final Color color = Colors.transparent;

//4
  @override
  void paint(Canvas canvas, Size size) {
    double srcX = spiedModel.rect["x"] * size.width;
    double srcY = spiedModel.rect["y"] * size.height;
    double srcH = spiedModel.rect["h"] * size.height;
    double srcW = spiedModel.rect["w"] * size.width;

    double l = srcX;
    double t = srcY;
    double w = srcW;
    double h = srcH;

    print([l, t, w, h]);
    final shapeBounds = Rect.fromLTWH(l, t, w, h);

    Paint wordPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0
      ..color = Colors.white;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.white;

    canvas.drawRect(shapeBounds, paint);
  }

//5
  @override
  bool shouldRepaint(ProfileCardPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

class DrawObject extends CustomPainter {
  SpiedModel spiedModel;
  GlobalKey<State<StatefulWidget>> keyCameraPreview;
  DrawObject(this.spiedModel, this.keyCameraPreview);

  @override
  void paint(Canvas canvas, Size size) {
    print(spiedModel);
    //  if (spiedModel==null) return;
    final RenderBox renderPreview =
        keyCameraPreview.currentContext.findRenderObject();
    final sizeRed = renderPreview.size;

    var ratioW = sizeRed.width / 416;
    var ratioH = sizeRed.height / 416;

    Paint paint = new Paint();
    paint.color = new Color.fromRGBO(255, 255, 255, 1);
    paint.strokeWidth = 2;
    var rect = spiedModel.rect;
    double x1 = rect["x"] * ratioW,
        x2 = rect["w"] * ratioW,
        y1 = rect["y"] * ratioH,
        y2 = rect["h"] * ratioH;
    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white,
            background: paint,
            fontWeight: FontWeight.bold,
            fontSize: 30),
        text: " *" + spiedModel.word);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(x1 + 1, y1 + 1));
    canvas.drawLine(new Offset(x1, y1), new Offset(x2, y1), paint);
    canvas.drawLine(new Offset(x1, y1), new Offset(x1, y2), paint);
    canvas.drawLine(new Offset(x1, y2), new Offset(x2, y2), paint);
    canvas.drawLine(new Offset(x2, y1), new Offset(x2, y2), paint);
  }

  @override
  bool shouldRepaint(DrawObject oldDelegate) {
    return true;
  }
}
