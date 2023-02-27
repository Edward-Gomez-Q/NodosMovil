import 'package:flutter/material.dart';
import 'package:grafo1/modelos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DB{
  static Future<Database>_openDB() async{
    final dbPath = await getDatabasesPath();
    return openDatabase(
        join(dbPath,'grafo.db'),
        onCreate: (db, version){
          db.execute(
            'CREATE TABLE GRAFO(id INTEGER PRIMARY KEY,Nombre TEXT, Descripcion TEXT, Nodos TEXT, Lineas Text, cantidadNodos INTEGER, cantidadLineas INTEGER)',
          );
        },
        version: 3);
  }
  //INSERTAR DATOS
  static Future<Future<int>> insert(modelo model) async{
    Database database= await _openDB();
    return database.insert('grafo', model.toMap());
  }
  //Cargar DAtos
  static Future<List<modelo>> cargarLista() async{
    Database database= await _openDB();
    final List<Map<String,dynamic>> modelosMap=await database.rawQuery('Select * from grafo');
    return List.generate(modelosMap.length,
            (i) => modelo(
            modelosMap[i]['id'],
            modelosMap[i]['Nombre'],
            modelosMap[i]['Descripcion'],
            modelosMap[i]['Nodos'],
                modelosMap[i]['Lineas'],
            modelosMap[i]['cantidadNodos'],
                modelosMap[i]['cantidadLineas'],)
    );
  }

  static Future<Future<int>> delete(modelo model) async{
    Database database= await _openDB();
    return database.delete('grafo',where: 'id=?',whereArgs: [model.id]);
  }

}