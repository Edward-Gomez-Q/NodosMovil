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
  _matrizState( this.matrizAdyacencia);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matriz de adyacencia"),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          children: matrizAdyacencia.map((row) {
            return TableRow(
              children: row.map((cell) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    cell.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              ).toList(),
            );
          }
          ).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        
      },),
    );
  }

}
