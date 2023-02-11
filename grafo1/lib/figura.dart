import 'package:flutter/material.dart';
import 'modelos.dart';
class Nodos extends CustomPainter{
  List<ModeloNodo>vNodo;
  double x2=0,y2=0;
  _msg(double x, double y,  String msg, Canvas canvas){
    TextSpan span = TextSpan(style: TextStyle(color: Colors.black,fontSize: 25, fontWeight:FontWeight.bold), text: msg);
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x,y));
  }
  Nodos(this.vNodo);
  @override
  void paint(Canvas canvas, Size size){

    Paint bor=new Paint()
    ..style=PaintingStyle.stroke
    ..color=Colors.black
    ..strokeWidth=5;
    Paint paint=new Paint()
    ..style=PaintingStyle.fill;
    vNodo.forEach((e) {
      if(!e.st)
      {
        paint..color=Colors.blue.shade600;
      }
      else
      {
          paint..color=Colors.red.shade600;
      }
      canvas.drawCircle(Offset(e.x, e.y), e.radio, paint);
      canvas.drawCircle(Offset(e.x, e.y), e.radio, bor);
      _msg(e.x-13,e.y-13,e.nombre,canvas);
    });
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}
class Lineas extends CustomPainter
{
  List<ModeloLinea> list;
  Lineas(this.list);
  _msg(double x, double y,  String msg, Canvas canvas){
    TextSpan span = TextSpan(style: TextStyle(color: Colors.black,fontSize: 25, fontWeight:FontWeight.bold), text: msg);
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x,y));
  }
  final linea = Paint()
    ..color = Colors.black
    ..strokeWidth = 4;
  @override
  void paint(Canvas canvas, Size size)
  {
    list.forEach((e) {
      final p1 = Offset(e.Ni.x, e.Ni.y);
      final p2 = Offset(e.Nf.x,e.Nf.y);
      canvas.drawLine(p1, p2, linea);
      _msg(((e.Ni.x+e.Nf.x)/2),((e.Ni.y+e.Nf.y)/2),e.valor,canvas);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
class LineasNuevas extends CustomPainter
{
  List<ModeloLinea> list;
  LineasNuevas(this.list);
  _msg(double x, double y,  String msg, Canvas canvas){
    TextSpan span = TextSpan(style: TextStyle(color: Colors.black,fontSize: 25, fontWeight:FontWeight.bold), text: msg);
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x,y));
  }
  final linea = Paint()
    ..color = Colors.purple
    ..strokeWidth = 4;
  @override
  void paint(Canvas canvas, Size size)
  {
    list.forEach((e) {
      final p1 = Offset(e.Ni.x, e.Ni.y);
      final p2 = Offset(e.Nf.x,e.Nf.y);
      canvas.drawLine(p1, p2, linea);
      _msg(((e.Ni.x+e.Nf.x)/2)+5,((e.Ni.y+e.Nf.y)/2)+5,"",canvas);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
class boceto extends CustomPainter
{
  Modeloboceto e;
  boceto(this.e);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    final p1 = Offset(e.x1, e.y1);
    final p2 = Offset(e.x2, e.y2);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}