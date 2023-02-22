import 'package:flutter/material.dart';
import 'modelos.dart';
class matriz extends StatefulWidget {
  final List<List<String>> matrizAdyacencia;
  const matriz(this.matrizAdyacencia, {Key? key}) : super(key: key);
  @override
  State<matriz> createState() => _matrizState(matrizAdyacencia);
}

class _matrizState extends State<matriz> {
  final List<List<String>> matrizAdyacencia;
  _matrizState(this.matrizAdyacencia);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matriz de adyacencia"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,

        children: [
          Text(vtext()),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        
      },),
    );
  }
  String vtext()
  {
    //print(matrizAdyacencia);
    String Ni="";
    matrizAdyacencia.forEach((element) {
      element.forEach((element2) {
        Ni=Ni+element2+" ";
      });
    });
    return Ni;
  }
}
