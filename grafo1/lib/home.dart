import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grafo1/HelpScreen.dart';
import 'package:grafo1/SqlLite/sql.dart';
import 'modelos.dart';
import 'figura.dart';
import 'matriz.dart';
class Myhome extends StatefulWidget {
  const Myhome({Key? key}) : super(key: key);
  //Nos envía a _MyhomeState
  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  //SQL
  List<modelo> modeloGuardado=[];
  int cantN=0,cantL=0;
  //Variable que recibe el valor de los mensajes
  TextEditingController receptorMensaje = TextEditingController();
  TextEditingController tituloGuardado=TextEditingController();
  TextEditingController descripcionGuardada=TextEditingController();
  /*Variable para controlar el modo:
  * Modo=1 : Crear Nodo
  * Modo=2 : Crear Conexión entre nodos
  * Modo=3 : Eliminar Nodo
  * Modo=4 : Mover Nodo
  * */
  int modo=-1;
  //Variable que cuenta la cantidad de nodos
  int contadorNodos=1;
  /*
  *  Variables que almacenan la posición donde se hace un toque
  * (x,y) variables que detectan el toque
  * (xi,yi) y (xf,yf) Son variables que solo se utilizan para la creación del boceto,
  * el cual solo se utiliza en el modo 2, es la linea que une los grafos, una vez
  * termina el proceso de unión de grafos, estas variables son 0
   */
  double x=0,y=0,xi=0,xf=0,yi=0,yf=0;
  /*
  * Variable booleana que solo se utiliza en modo 2, nos dice si el primer toque fue realizado en un nodo,
  * True = El primer toque cae en un nodo
  * False = El primer toque no cae en un nodo
   */
  bool flagBoceto=false;
  //Variable Auxiliar que almacena un nodo
  ModeloNodo nodoAux= new ModeloNodo(0,0,0,"","", false);
  //Variable Auxiliar que almacena una Linea
  late ModeloLinea lineaAux;
  late int ID;
  //Lista de Nodos
  List<ModeloNodo> vNodo=[];
  //Lista de Lineas
  List<ModeloLinea> vLineas=[];
  //Lista auxiliar para remover lineas
  List<ModeloLinea> vLineasRemove=[];
  @override
  void initState() {
    cargaModelo();
    super.initState();
  }
  Future cargaModelo() async{
    List<modelo> auxModelo= await DB.cargarLista();
    setState(() {
      modeloGuardado=auxModelo;
    });
  }
  @override
  Widget build(BuildContext context) {
    //Aplicación
    return MaterialApp(
      home: Scaffold(
        //Pila que almacena todos los objetos
        body: Stack(
          children: [
            //Dibuja todos los bocetos
            CustomPaint(
              painter: boceto(Modeloboceto(xi, yi, xf, yf)),
            ),
            //Dibuja todas las lineas
            CustomPaint(
              painter: Lineas(vLineas),

            ),
            //Dibuja todos los Nodos
            CustomPaint(
              painter: Nodos(vNodo),
            ),
            //Detector de toques en la pantalla
            GestureDetector(
              /*
              * onPan es un atributo de GestureDetector que reconoce el moviento arrastrado, usaremos:
              * onPanStart, onPanUpdate y onPanEnd
              * onPanStart detecta donde inicio el arrastre, este dato esta almacenado en la variable pos
               */
              onPanStart: (pos) {
                // dividimos la variable pos en 2 => (x,y)
                x=pos.globalPosition.dx;
                y=pos.globalPosition.dy;
                //Si modo = 2, o sea el modo de unir dos nodos
                if(modo==2)
                {
                  //forEach que recorre toda la lista de Nodos, y almancena el nodo en la variable e
                  vNodo.forEach((e) {
                    //Si la posición inicial cae en un nodo, entramos al if
                    if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                    {
                      //flagBoceto en true ya que reconoció un nodo inicial
                      flagBoceto=true;
                      /*
                       * Cambio de color del nodo
                       * True=Rojo
                       * False=Azul
                       */
                      e.color=true;
                      //Almancena el nodo inicial en la variable nodoAux
                      nodoAux=e;
                      //Almacena la posición inicial en (xi,yi)
                      xi=x;
                      yi=y;
                      //El metodo setState actualiza todos los valores para la pantalla
                      setState(() {
                      });
                    }
                  });
                }
                //Si modo = 4, o sea el modo de Mover Nodo
                else if(modo==4)
                {
                  //forEach que recorre toda la lista de Nodos, y almancena el nodo en la variable e
                  vNodo.forEach((e) {
                    //Si la posición inicial cae en un nodo, entramos al if
                    if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                    {
                      //Cambio de color del nodo
                      e.color=true;
                      //Nodo inicial almacenado en la variable e
                      nodoAux=e;
                    }
                  });
                }
              },
              //onPanEnd nos permite accionar al final de un arrastre, pero no nos da la posición de la misma
              onPanEnd: (details) {
                //Si modo = 2, o sea el modo de unir dos nodos
                if(modo==2)
                {
                  //Recorre la lista de nodos para ver si la ultima posición registrada en (xf,yf) cae en un nodo
                  vNodo.forEach((e) {
                    //Si la posición final cae en un nodo, entramos al if
                    if(xf<(e.x+e.radio)&&xf>(e.x-e.radio)&&yf<(e.y+e.radio)&&yf>(e.y-e.radio))
                    {

                      if(e==nodoAux)
                      {
                        if(verificaConexion(e))
                        {
                          _showDialogCambio(context,e,lineaAux);
                        }
                        else
                        {
                          _showDialog2(context);
                        }

                      }
                      //Verifica si ya hubo una conexión entre los dos nodos
                      else if(verificaConexion(e))
                      {
                        //Si ya hubo una conexión vacía el receptor de mensaje
                        receptorMensaje.clear();
                        //Muestra una alerta para pedir el nuevo número que será asignado a la conexión
                        _showDialogCambio2(context,e,lineaAux);
                      }
                      else
                      {
                        //Muestra una alerta para pedir el número que será asignado a la conexión

                        setState(() {
                          _showDialog(context,e);
                        });
                      }
                    }
                  });
                  //una vez terminado el proceso se restable el boceto en 0
                  eliminarBoceto();
                  //Se cambia el color del nodo inicial a azul
                  nodoAux.color=false;
                  //El metodo setState actualiza todos los valores para la pantalla
                  setState(() {
                  });
                }
                else if(modo==4)
                {
                  //Cambia el color del nodo Azul
                  nodoAux.color=false;
                  setState(() {
                  });
                }
              },
              //onPanUpdate detecta la posición por la cual es arrastrado el nodo, esta se guarda en pos
              onPanUpdate: (pos) {
                //Si modo = 2
                if(modo==2)
                {
                  //Si flagBoceto=true, o sea si al principio del arrastre se reconoción un nodo inicial
                  if(flagBoceto)
                  {
                    /*
                    * Ya que reconoce la posición miestras arrastramos un nodo, necesitamos trabajar en un setState
                    * debido a que los valores siempre son actualizados
                     */
                    setState(() {
                      //posicion actual del arrastre almacenado en (x,y) y una posible posicion final en (xf,yf)
                      x=pos.globalPosition.dx;
                      y=pos.globalPosition.dy;
                      xf=x;
                      yf=y;
                      //Recorre la lista de nodos
                      vNodo.forEach((e) {
                        //Verifica si la posicion actual esta en el area de un nodo
                        if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio) )
                        {
                          //Si la posición cae en un nodo este nodo cambia de color a rojo
                          e.color=true;
                        }
                        else
                        {
                          //Aquí cambiamos el color de todos los nodos a azul menos del nodo Inicial que sigue en rojo
                          if(e!=nodoAux)
                          {
                            e.color=false;
                          }
                        }
                      });
                    });
                  }
                }
                else if(modo==4)
                {
                  //Actualiza la posición del nodo y tambien actualiza esto en la pantalla
                  setState(() {
                    nodoAux.x=pos.globalPosition.dx;
                    nodoAux.y=pos.globalPosition.dy;
                  });
                }
              },
              //Usaremos onPanDown para registrar un toque de pantalla, la ubicación esta almacenada en la variable ubi
              onPanDown: (ubi) {
                x=ubi.globalPosition.dx;
                y=ubi.globalPosition.dy;
                setState(() {
                  //Si modo=1, o sea queremos crear un nodo
                  if(modo==1)
                  {
                    //Añade un nuevo nodo a la lista de nodos con los datos de su posición y su número
                    vNodo.add(ModeloNodo(ubi.globalPosition.dx,ubi.globalPosition.dy,50,"$contadorNodos","$contadorNodos",false));
                    //el numero de nodos suber en 1
                    contadorNodos++;

                  }
                });
              },
              //onTapDown registra un toque en la pantalla, su posición esta almacenada en pos
              onTapDown: (pos) {
                x=pos.globalPosition.dx;
                y=pos.globalPosition.dy;
                //Si modo = 3, o sea eliminar nodo
                if(modo==3)
                  {
                    vNodo.forEach((e) {
                      if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                        {
                          //Nos envía a la función _showDialogEliminar donde nos pedirá que confirmemos la eliminación
                          _showDialogEliminar(context, e);
                        }
                    });
                  }
                else if(modo == 5){
                  vNodo.forEach((e) {
                    if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                    {
                      //Nos envía a la función _showDialogEliminar donde nos pedirá que confirmemos la eliminación
                      _showCambioNodo(context, e);
                    }
                  });

                }

              },
            )
          ],

        ),
        //Barra de navegación ubicada al final
        bottomNavigationBar: BottomAppBar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //botón para poner el modo 1
                IconButton(
                    onPressed: (){
                      setState(() {
                        modo=1;
                        eliminarBoceto();
                      });
                    },
                    icon: Icon(Icons.add),

                    tooltip: 'Nuevo Nodo',
                ),
                //botón para poner el modo 2
                IconButton(
                  onPressed: (){
                    setState(() {
                      modo=2;
                      eliminarBoceto();
                    });
                  },
                  icon: Icon(Icons.flag),
                  tooltip: 'Unir Nodo',
                ),
                //botón para poner el modo 3
                IconButton(
                  onPressed: (){
                    setState(() {
                      modo=3;
                      eliminarBoceto();
                    });
                  },
                  icon: Icon(Icons.delete),
                  tooltip: 'eliminar',
                ),
                //botón para poner el modo 4
                IconButton(
                  onPressed: (){
                    setState(() {
                      modo=4;
                      eliminarBoceto();
                    });
                  },
                  icon: Icon(Icons.drive_file_move_rounded),
                  tooltip: 'Mover Nodo',
                ),
                //botón para restablecer todos los valores iniciales
                IconButton(
                  onPressed: (){
                    setState(() {
                      modo=-1;
                      vNodo.clear();
                      contadorNodos=1;
                      vLineas.clear();
                      setState(() {
                        eliminarBoceto();
                      });
                    });
                  },
                  icon: Icon(Icons.delete_forever),
                  tooltip: 'Vaciar',
                ),
                IconButton(onPressed: () {
                  setState(() {
                    //Matriz de Adyacencia
                    List<List<String>> matrizAdyacencia=[];
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => matriz(generaMatriz(matrizAdyacencia))));
                  });
                }, icon: Icon(Icons.table_view),
                  tooltip: 'Ver Tabla',
                ),
                IconButton(onPressed:() {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpScreen()));
                  });
                }, icon: Icon(Icons.help)),
                IconButton(
                  onPressed: (){
                    setState(() {
                      modo = 5;
                      eliminarBoceto();

                    });
                  },
                  icon: Icon(Icons.edit_outlined),
                  tooltip: 'Editar',
                ),
                IconButton(onPressed:() {
                  setState(() {
                    cantN=0;
                    cantL=0;
                    String cifraNodo=cifradoNodos();
                    String cifraLinea=cifradoLineas();
                    _MensajeGuardado(context,cifraNodo,cifraLinea);
                    setState(() {

                    });
                  });
                }, icon: Icon(Icons.save),
                tooltip: 'Guardar',),
                IconButton(onPressed:() {
                  setState(() {
                    _MensajeCargar(context);
                    setState(() {

                    });
                  });
                }, icon: Icon(Icons.save_as_sharp),
                  tooltip: 'Cargar',),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String cifradoNodos(){
    String cifrado="";
    vNodo.forEach((Nodo) {
      cantN++;
      cifrado=cifrado+Nodo.x.toStringAsPrecision(7)+","+Nodo.y.toStringAsPrecision(7)+","+Nodo.radio.toString()+","+Nodo.codigo+","+Nodo.st.toString()+";";
    });
    return cifrado;
  }
  String cifradoLineas(){
    String cifrado="";
    vLineas.forEach((Linea) {
      cantL++;
      cifrado=cifrado+Linea.Ni.codigo+","+Linea.Nf.codigo+","+Linea.valor+","+Linea.tipo.toString()+";";
    });
    return cifrado;
  }
  void descrifrado(modelo cifrado){
    vNodo.clear();
    List<String> ListaNodos = cifrado.Nodos.split(";");
    for(int i=0;i<cifrado.cantidadNodos;i++)
    {
      List<String> Nodo=ListaNodos[i].split(",");
      vNodo.add(ModeloNodo(double.parse(Nodo[0]), double.parse(Nodo[1]), double.parse(Nodo[2]),Nodo[3],Nodo[3],false));
    }
    vLineas.clear();
    List<String> ListaLineas=cifrado.Lineas.split(";");
    print(ListaLineas);
    for(int i=0;i<cifrado.cantidadLineas;i++)
    {
      ModeloNodo Nii=vNodo[0];
      ModeloNodo Nff=vNodo[0];
      List<String> Linea=ListaLineas[i].split(',');
      vNodo.forEach((Nodo) {
        if(Nodo.codigo==Linea[0])
        {
          Nii=Nodo;
        }
        if(Nodo.codigo==Linea[1])
        {
          Nff=Nodo;
        }
      });
      vLineas.add(ModeloLinea(Nii, Nff, Linea[2], int.parse(Linea[3])));
    }

  }
  List<List<String>> generaMatriz(List<List<String>> matrizAdyacencia)
  {
    matrizAdyacencia.clear();
    List<String> v2=[];
    v2.add(" ");
    vNodo.forEach((ele) {v2.add((ele.nombre));});
    matrizAdyacencia.add(v2);
    for(int i=0;i<vNodo.length;i++)
    {
      List<String> v=[];
      v.clear();
      String vr=v2[i+1];
      v.add(vr);
      for(int r=0;r<vNodo.length;r++)
      {
        v.add("0");
      }
      matrizAdyacencia.add(v);
    }
    vLineas.forEach((linea){
      print('Fila= '+linea.Ni.codigo + " Columna=" +linea.Nf.codigo + " valor=" +linea.valor +" tipo="+linea.tipo.toString());
      int f=int.parse(linea.Ni.codigo);
      int c=int.parse(linea.Nf.codigo);
      int valorLinea=int.parse(linea.valor);
      if(linea.tipo==0)
      {
        List<String> fila=[...matrizAdyacencia[c]];
        fila[f]=valorLinea.toString();
        matrizAdyacencia[c]=fila;

        print(fila);
      }
      List<String> fila=[...matrizAdyacencia[f]];
      fila[c]=valorLinea.toString();
      matrizAdyacencia[f]=fila;
    });
    return matrizAdyacencia;
  }
//Función eliminar lineas, llamada por la función _showDialogEliminar
  void eliminarLineas(ModeloNodo e)
  {
    //Recorre la lista de Lineas
    vLineas.forEach((element) {
      //Busca lineas que contenga al nodo a eliminar,
      if(element.Ni==e || element.Nf==e)
      {
        //Añade las lineas a ser eliminadas a la lista auxiliar
        vLineasRemove.add(element);
      }
    });
    //el metodo removeWhere elimina todos los valores de una lista según otra lista
    vLineas.removeWhere((element) => vLineasRemove.contains(element));
  }

  //Restablece los valores del boceto
  void eliminarBoceto()
  {
    flagBoceto=false;
    xi=0;
    yi=0;
    xf=0;
    yf=0;
  }
  //Mensaje de alerta para la eliminación de un nodo
  _showDialogEliminar(context,ModeloNodo e)
  {
    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            //Titulo del mensaje
            title: Text("CONFIRMAR ELIMINACIÓN"),
            //Cuerpo del mensaje
            content: Text("Se eliminará el nodo y sus conexiones."),
            actions: [
              //Botón del mensaje para confirmar la eliminación
              TextButton(onPressed: () {
                //Elimina todas las lineas del nodo a eliminar
                eliminarLineas(e);
                //elimina al nodo
                vNodo.remove(e);

                setState(() {

                });
                //sale del mensaje
                Navigator.of(context).pop();
              }, //Mensaje del botón
                  child: Text("OK")),
              //Botón del mensaje de cancelar eliminación
              TextButton(
                  onPressed: (){
                    //sale del mensaje
                    Navigator.of(context).pop();
                  },
                  //Mensaje del botón
                  child: Text("Cancel")
              ),
            ],
          );
        });
  }
  //Mensaje de alerta para la Unir dos nodos
  int? _valueLinea;
  _showDialog(context, ModeloNodo e)
  {
    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(
              builder: (context,newsetState){
                return AlertDialog(
                  //Titulo del mensaje
                  title: Text("INTRODUZCA UN VALOR"),
                  //TextField para recibir un valor
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        //Teclado solo tenga numeros
                        keyboardType: TextInputType.number,
                        //valor numerico almacenado en receptorMensaje
                        controller: receptorMensaje,
                        
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(e.codigo),
                            DropdownButton(
                              items: const [
                                DropdownMenuItem(value: 0,child: Text('----'),),
                                DropdownMenuItem(value: 1,child: Text('<---'),),
                                DropdownMenuItem(value: 2,child: Text('--->'),),
                              ],

                              value: _valueLinea,
                              onChanged: (value) {
                                newsetState(() {
                                  _valueLinea=value;
                                  print(_valueLinea);
                                });
                                setState(() {

                                });
                              },
                            ),
                            Text(nodoAux.codigo),]
                      ),
                    ],
                  ),


                  actions: [
                    //Confirma la unión de nodos
                    TextButton(
                        onPressed: (){
                          //crea una nueva Linea entre los nodos
                          if(_valueLinea==2)
                          {
                            ModeloLinea h=ModeloLinea(e,nodoAux,receptorMensaje.text,1);
                            vLineas.add(h);
                          }
                          else
                          {
                            ModeloLinea h=ModeloLinea(nodoAux,e,receptorMensaje.text,_valueLinea!);
                            vLineas.add(h);
                          }
                          //Cambia el color del nodo inicial a azul
                          e.color=false;

                          //sale del mensaje
                          Navigator.of(context).pop();
                          setState(() {
                          });
                        },
                        //texto del boton
                        child: Text("OK")
                    ),
                    //cancela la unión de nodos
                    TextButton(
                        onPressed: (){
                          //Cambia el color del nodo inicial a azul
                          e.color=false;
                          setState(() {
                          });
                          //sale del mensaje
                          Navigator.of(context).pop();
                        },
                        //texto del boton
                        child: Text("Cancel")
                    ),
                  ],
                );
              } );
        });
  }
  _showDialog2(context)
  {
    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            //Titulo del mensaje
            title: Text("INTRODUZCA UN VALOR"),
            //TextField para recibir un valor
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  //Teclado solo tenga numeros
                  keyboardType: TextInputType.number,
                  //valor numerico almacenado en receptorMensaje
                  controller: receptorMensaje,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                ),
              ],
            ),
            actions: [
              //Confirma la unión de nodos
              TextButton(
                  onPressed: (){
                    //crea una nueva Linea entre los nodos
                    ModeloLinea h=ModeloLinea(nodoAux,nodoAux,receptorMensaje.text,3);
                    vLineas.add(h);
                    //Cambia el color del nodo inicial a azul
                    nodoAux.color=false;
                    setState(() {
                    });
                    //sale del mensaje
                    Navigator.of(context).pop();
                  },
                  //texto del boton
                  child: Text("OK")
              ),
              //cancela la unión de nodos
              TextButton(
                  onPressed: (){
                    //Cambia el color del nodo inicial a azul
                    nodoAux.color=false;
                    setState(() {
                    });
                    //sale del mensaje
                    Navigator.of(context).pop();
                  },
                  //texto del boton
                  child: Text("Cancel")
              ),
            ],
          );
        });
  }
  //Función que verifica si ya hubo conexión entre los nodos
  bool verificaConexion(ModeloNodo e)
  {
    //resultado default false, o sea no hay conexión
    bool result=false;
    //recorre la lista de lineas
    vLineas.forEach((element) {
      //Verifica si ya hay una conexión entre el nodo inicial(nodoAux) y el nodo final (e)
      if((element.Ni==nodoAux && element.Nf==e)||(element.Ni==e && element.Nf==nodoAux))
      {
        //En el caso de que haya una conexión anterior, almacenamos esta conexión
        //en lineaAux para posteriormente cambiar su valor
        lineaAux=element;
        result=true;
      }
    });
    return result;
  }
  //Mensaje para cambiar el valor de una conexión
  _showDialogCambio(context, ModeloNodo e,ModeloLinea h)
  {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            //titulo del mensaje
            title: Text("CAMBIE EL VALOR"),
            content:


            TextField(
              //teclado solo con numeros
              keyboardType: TextInputType.number,
              //valor numerico almacenado en receptorMensaje
              controller: receptorMensaje,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),

            actions: [
              //Confirma el cambio
              TextButton(
                  onPressed: (){
                    //cambia el valor de la conexión por el nuevo valor
                    // String inputValue = receptorMensaje.text;
                    // if(int.tryParse(inputValue) != null){
                    //   int out = int.parse(receptorMensaje.text);
                    //   h.valor = out.toString();
                    //   e.color=false;
                    //   setState(() {
                    //   });
                    //   Navigator.of(context).pop();
                    // } else{
                    //   print('Error critico xd');
                    // }
                    h.valor=receptorMensaje.text;
                    e.color=false;
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")
              ),
              //cancela el cambio
              TextButton(
                  onPressed: (){
                    e.color=false;
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")
              ),
            ],
          );
        });
  }
  _showDialogCambio2(context, ModeloNodo e,ModeloLinea h)
  {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(builder: (context,newsetState){
            return AlertDialog(
              //titulo del mensaje
              title: Text("CAMBIE EL VALOR"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    //Teclado solo tenga numeros
                    keyboardType: TextInputType.number,
                    //valor numerico almacenado en receptorMensaje
                    controller: receptorMensaje,
                    
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(e.codigo),
                        DropdownButton(
                          items: const [
                            DropdownMenuItem(value: 0,child: Text('----'),),
                            DropdownMenuItem(value: 1,child: Text('<---'),),
                            DropdownMenuItem(value: 2,child: Text('--->'),),
                          ],

                          value: _valueLinea,
                          onChanged: (value) {
                            newsetState(() {
                              _valueLinea=value;
                              print(_valueLinea);
                            });
                            setState(() {

                            });
                          },
                        ),
                        Text(nodoAux.codigo),]
                  ),
                ],
              ),

              actions: [
                //Confirma el cambio
                TextButton(
                    onPressed: (){
                      //cambia el valor de la conexión por el nuevo valor

                      h.valor=receptorMensaje.text;
                      if(_valueLinea==0)
                      {
                        h.tipo=_valueLinea!;
                      }
                      else if(_valueLinea==1)
                      {
                        h.Ni=nodoAux;
                        h.Nf=e;
                        h.tipo=1;
                      }
                      else {
                        h.Nf=nodoAux;
                        h.Ni=e;
                        h.tipo=1;
                      }
                      e.color=false;
                      setState(() {
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")
                ),
                //cancela el cambio
                TextButton(
                    onPressed: (){
                      e.color=false;
                      setState(() {
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")
                ),
              ],
            );
          });
        });
  }
  _showCambioNodo(context, ModeloNodo e)
  {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(builder: (context,newsetState){
            return AlertDialog(
              //titulo del mensaje
              title: Text("CAMBIE NOMBRE DE NODO"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    //Teclado solo tenga numeros

                    //valor numerico almacenado en receptorMensaje
                    controller: receptorMensaje,
                  ),

                ],
              ),

              actions: [
                //Confirma el cambio
                TextButton(
                    onPressed: (){
                      //cambia el valor de la conexión por el nuevo valor
                      e.nombre =receptorMensaje.text;

                      e.color=false;
                      setState(() {
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")
                ),
                //cancela el cambio
                TextButton(
                    onPressed: (){
                      e.color=false;
                      setState(() {
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")
                ),
              ],
            );
          });
        });
  }
  _MensajeGuardado(context,String cifraNodo,String cifraLinea)
  {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            //titulo del mensaje
            title: Text("GUARDADO DE GRAFO"),
            content:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  //valor numerico almacenado en receptorMensaje
                  controller: tituloGuardado,
                  decoration: InputDecoration(
                      hintText: 'Introduzca un Nombre',
                  ),
                ),
                TextField(
                  controller: descripcionGuardada,
                  decoration: InputDecoration(
                    hintText: 'Introduzca una descripción'
                  ),
                ),
                Text('Cantidad de Nodos: ${cantN}'),
                Text('Cantidad de Conexiones: ${cantL}')
              ],
            ),
            actions: [
              //Confirma el guardado
              TextButton(
                  onPressed: (){
                    setState(() {
                      if(modeloGuardado.isEmpty)
                      {
                        ID=0;
                      }
                      else
                      {
                        ID=modeloGuardado[modeloGuardado.length-1].id+1;
                      }
                      DB.insert(modelo(ID,tituloGuardado.text,descripcionGuardada.text,cifraNodo,cifraLinea,cantN,cantL));
                      cargaModelo();
                      setState(() {

                      });

                    });
                    Navigator.of(context).pop();

                  },
                  child: Text("OK")
              ),
              //cancela el cambio
              TextButton(
                  onPressed: (){
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")
              ),
            ],
          );
        });
  }
  _MensajeCargar(context)
  {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        builder: (context){
          return AlertDialog(
            //titulo del mensaje
            title: Text("CARGADO DE GRAFO"),
            content:Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seleccione la configuración:'),
                Container(
                  color: Colors.blue,
                  height: 300,
                  width: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: modeloGuardado.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('${modeloGuardado[index].id}'),
                                VerticalDivider(

                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${modeloGuardado[index].Codigo}'),
                                    Text('Lineas: ${modeloGuardado[index].cantidadLineas}'),
                                    Text('Nodos: ${modeloGuardado[index].cantidadNodos}'),
                                    Text('Descripción:'),
                                    Container(
                                      height: 56,
                                      width: 150,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text('${modeloGuardado[index].Descripcion}'),
                                      ),

                                    )
                                  ],
                                )
                              ],
                            ),
                            onTap: () {
                             setState(() {
                               Navigator.of(context).pop();
                               _confirmarCargado(context, index);
                             });
                            },
                            onLongPress: () {
                              setState(() {
                                Navigator.of(context).pop();
                                _confirmarEliminacion(context, index);
                              });
                            },
                          ),

                        );
                      },

                    ),
                  ),
                ),
              ],
            ),
            actions: [
              //Confirma el guardado
              TextButton(
                  onPressed: (){
                    setState(() {
                    });
                    Navigator.of(context).pop();

                  },
                  child: Text("OK")
              ),
              //cancela el cambio
              TextButton(
                  onPressed: (){
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")
              ),
            ],
          );
        });
  }
  _confirmarEliminacion(context,int index)
  {
    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            //Titulo del mensaje
            title: Text("SEGURO QUE QUIERE ELIMINAR EL GRAFO?"),
            actions: [
              //Confirma la unión de nodos
              TextButton(
                  onPressed: (){
                    setState(() {
                      DB.delete(modeloGuardado[index]);
                      cargaModelo();
                      Navigator.of(context).pop();

                    });
                  },
                  //texto del boton
                  child: Text("OK")
              ),
              //cancela la unión de nodos
              TextButton(
                  onPressed: (){
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  //texto del boton
                  child: Text("Cancel")
              ),
            ],
          );
        });
  }
  _confirmarCargado(context,int index)
  {
    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            //Titulo del mensaje
            title: Text("SEGURO QUE QUIERE CARGAR EL GRAFO?"),
            actions: [
              //Confirma la unión de nodos
              TextButton(
                  onPressed: (){
                    setState(() {
                      descrifrado(modeloGuardado[index]);
                      Navigator.of(context).pop();
                    });
                  },
                  //texto del boton
                  child: Text("OK")
              ),
              //cancela la unión de nodos
              TextButton(
                  onPressed: (){
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  //texto del boton
                  child: Text("Cancel")
              ),
            ],
          );
        });
  }

}
