import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            ListTile(
              title: const Icon(Icons.add),
              subtitle: const Text('Con este boton podremos añadir la cantidad de nodos que queramos tocando cualquier lugar de la pantalla\n'),
            ),
            ListTile(
              title: const Icon(Icons.flag),
              subtitle: const Text('Con este boton podremos unir dos nodos arrastrando desde un nodo a otro, al seleccionar unir los nodos nos mostrara las opciones de conexion como ser:\n'
                  '\t---\testa conexion señala que el valor de la conexion no tendra direccion y sera la misma para ambos lados\n'
                  '\t-->\testa conexion tiene la dirección desde un nodo a otro pero no biseversa\n'),
            ),
            ListTile(
              title: const Icon(Icons.delete),
              subtitle: const Text('Con este boton podremos eliminar el nodo que toquemos en la pantalla\n'),
            ),
            ListTile(
              title: const Icon(Icons.drive_file_move),
              subtitle: const Text('Con este boton podremos mover cualquier nodo arrastrandolo por la pantalla\n'),
            ),
            ListTile(
              title: const Icon(Icons.delete_forever),
              subtitle: const Text('Con este boton podremos limpiar toda la pantalla\n'),
            ),
            ListTile(
              title: const Icon(Icons.table_view),
              subtitle: const Text('Con este boton podremos generar la matriz de adyasencia\n'),
            ),

            ListTile(
              title: const Icon(Icons.edit_outlined),
              subtitle: const Text('Con este boton podremos editar el nombre de los nodos\n'),
            ),
            ListTile(
              title: const Icon(Icons.save),
              subtitle: const Text('Con este boton podremos guardar el diseño de los nodos\n'),
            ),
            ListTile(
              title: const Icon(Icons.save_as_sharp),
              subtitle: const Text('Con este boton podremos cargar diseños almacenados en la aplicación\n'),
            ),
          ],
        ),
      )
    );
  }
}
