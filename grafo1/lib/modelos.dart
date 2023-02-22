import 'package:flutter/material.dart';
//Aquí estan todas las clases que vamos a usar

//Clase nodo
class ModeloNodo
{
  //posición y radio
  double _x,_y,_radio;
  //numero
  String _nombre;
  //valor de su color: rojo o azul
  bool _st;
  //constructor
  ModeloNodo(this._x, this._y, this._radio, this._nombre,this._st);
  //getters y setters
  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  get radio => _radio;

  set radio(value) {
    _radio = value;
  }

  get y => _y;

  set y(value) {
    _y = value;
  }

  double get x => _x;

  set x(double value) {
    _x = value;
  }

  bool get st => _st;

  set color(bool value) {
    _st = value;
  }
}
//Modelo Boceto
class Modeloboceto{
  //Posición donde empieza y donde termina
  double _x1,_y1,_x2,_y2;
  //constructor
  Modeloboceto(this._x1, this._y1, this._x2, this._y2);
  // setters and getters
  get y2 => _y2;

  set y2(value) {
    _y2 = value;
  }

  get x2 => _x2;

  set x2(value) {
    _x2 = value;
  }

  get y1 => _y1;

  set y1(value) {
    _y1 = value;
  }

  double get x1 => _x1;

  set x1(double value) {
    _x1 = value;
  }
}
//Modelo Linea
class ModeloLinea{
  //Nodo inicial y final
  ModeloNodo _Ni,_Nf;
  //valor
  String _valor;
  //Tipo
  int tipo;
  //constructor
  ModeloLinea(this._Ni, this._Nf, this._valor,this.tipo);
  //getters and setters
  String get valor => _valor;

  set valor(String value) {
    _valor = value;
  }

  ModeloNodo get Nf => _Nf;

  set Nf(ModeloNodo value) {
    _Nf = value;
  }

  ModeloNodo get Ni => _Ni;

  set Ni(ModeloNodo value) {
    _Ni = value;
  }
}
