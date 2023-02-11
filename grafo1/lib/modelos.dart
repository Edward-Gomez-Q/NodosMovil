import 'package:flutter/material.dart';
class ModeloNodo{
  double _x,_y,_radio;
  String _nombre;
  bool _st;
  ModeloNodo(this._x, this._y, this._radio, this._nombre,this._st);
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

  set sta(bool value) {
    _st = value;
  }
}
class Modeloboceto{
  double _x1,_y1,_x2,_y2;
  Modeloboceto(this._x1, this._y1, this._x2, this._y2);

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

class ModeloLinea{
  ModeloNodo _Ni,_Nf;
  String _valor;

  ModeloLinea(this._Ni, this._Nf, this._valor);

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
