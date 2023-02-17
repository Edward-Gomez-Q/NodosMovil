import 'package:flutter/material.dart';
import 'modelos.dart';
//Aqui configuramos las formas del nodo y las lineas
//Configuración del nodo
class Nodos extends CustomPainter{
  //lista del nodos que recibimos del home.dart
  List<ModeloNodo>vNodo;
  //Función que configura la posición de los mensajes
  _msg(double x, double y,  String msg, Canvas canvas){
    TextSpan span = TextSpan(style: TextStyle(color: Colors.black,fontSize: 25, fontWeight:FontWeight.bold), text: msg);
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x,y));
  }
  //constructor
  Nodos(this.vNodo);
  //Aqui configuramos el nodo
  @override
  void paint(Canvas canvas, Size size){
    //pincel de color negro y grosor de 5 para el borde del nodo
    Paint bor=new Paint()
    ..style=PaintingStyle.stroke
    ..color=Colors.black
    ..strokeWidth=5;
    //pincel para el relleno del nodo
    Paint paint=new Paint()
    ..style=PaintingStyle.fill;
    //recorremos la lista de nodos
    vNodo.forEach((e) {
      //segun su valor de st, configuramos el color del nodo
      if(!e.st)
      {
        //false=azul
        paint..color=Colors.blue.shade600;
      }
      else
      {
        //true=rojo
          paint..color=Colors.red.shade600;
      }
      //dibujamos el relleno
      canvas.drawCircle(Offset(e.x, e.y), e.radio, paint);
      //dibujamos el borde del nodo
      canvas.drawCircle(Offset(e.x, e.y), e.radio, bor);
      //dibujamos el mensaje
      _msg(e.x-13,e.y-13,e.nombre,canvas);
    });
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}
//Aquí configuramos las lineas
class Lineas extends CustomPainter
{
  //Listado de lineas que nos llega de home.dart
  List<ModeloLinea> list;
  //constructor
  Lineas(this.list);
  //función para los mensajes
  _msg(double x, double y,  String msg, Canvas canvas){
    TextSpan span = TextSpan(style: TextStyle(color: Colors.black,fontSize: 25, fontWeight:FontWeight.bold), text: msg);
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x,y));
  }
  //configuramos la linea de color negro y grosor 4
  final linea = Paint()
    ..color = Colors.black
    ..strokeWidth = 4;
  //aqui dibujamos
  @override
  void paint(Canvas canvas, Size size)
  {
    //recoremos la lista de lineas
    list.forEach((e) {
      //guardamos la posición de los nodos en offset
      final p1 = Offset(e.Ni.x, e.Ni.y);
      final p2 = Offset(e.Nf.x,e.Nf.y);
      //dibujamos la linea con los offset
      canvas.drawLine(p1, p2, linea);
      //dibujamos el mensaje
      _msg(((e.Ni.x+e.Nf.x)/2),((e.Ni.y+e.Nf.y)/2),e.valor,canvas);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
//Aqui dibujamos el boceto
class boceto extends CustomPainter
{
  //Variable boceto que tiene 2 posiciones, (xi,yi) y (xf,yf)
  Modeloboceto e;
  //constructor
  boceto(this.e);
  //dibujamos el boceto
  @override
  void paint(Canvas canvas, Size size) {
    //pincel del boceto de color negro y grosor 4
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    //dibujamos el boceto
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