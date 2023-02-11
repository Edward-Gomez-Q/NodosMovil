import 'package:flutter/material.dart';
import 'modelos.dart';
import 'figura.dart';
class Myhome extends StatefulWidget {
  const Myhome({Key? key}) : super(key: key);

  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  TextEditingController ted1 = TextEditingController();
  int modo=-1;
  int cont=1;
  int contf=0;
  double x=0,y=0,xi=0,xf=0,yi=0,yf=0;
  bool flagBoceto=false;
  ModeloNodo g= new ModeloNodo(0,0,0,"", false);
  late ModeloLinea k;
  List<ModeloNodo> vNodo=[];
  List<ModeloLinea> vLineas=[];
  List<ModeloLinea> vLineasRemove=[];
  //----------------------
  List<ModeloLinea> vLineasNuevas=[];
  int contador=0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            CustomPaint(
              painter: boceto(Modeloboceto(xi, yi, xf, yf)),
            ),
            CustomPaint(
              painter: Lineas(vLineas),
            ),
            CustomPaint(
              painter: LineasNuevas(vLineasNuevas),
            ),
            CustomPaint(
              painter: Nodos(vNodo),
            ),


            GestureDetector(
              onPanStart: (pos) {
                x=pos.globalPosition.dx;
                y=pos.globalPosition.dy;
                if(modo==2)
                {
                  vNodo.forEach((e) {
                    if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                    {
                      flagBoceto=true;
                      e.sta=true;
                      g=e;
                      xi=x;
                      yi=y;
                      setState(() {
                      });
                    }
                  });
                }
                else if(modo==4)
                {
                  vNodo.forEach((e) {
                    if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                    {
                      e.sta=true;
                      g=e;
                    }
                  });
                }
              },
              onPanEnd: (details) {
                if(modo==2)
                {
                  vNodo.forEach((e) {
                    if(xf<(e.x+e.radio)&&xf>(e.x-e.radio)&&yf<(e.y+e.radio)&&yf>(e.y-e.radio))
                    {
                      if(verificaConexion(e))
                      {
                        ted1.clear();
                        _showDialogCambio(context,e,k);
                      }
                      else
                      {
                        _showDialog(context,e);
                      }
                    }
                  });
                  eliminarBoceto();
                  g.sta=false;
                  setState(() {
                  });
                }
                else if(modo==4)
                {
                  g.sta=false;
                  setState(() {
                  });
                }
              },
              onPanUpdate: (pos) {
                if(modo==2)
                {
                  if(flagBoceto)
                  {
                    setState(() {
                      x=pos.globalPosition.dx;
                      y=pos.globalPosition.dy;
                      xf=x;
                      yf=y;
                      vNodo.forEach((e) {
                        if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio) )
                        {
                          e.sta=true;
                        }
                        else
                        {
                          if(e!=g)
                          {
                            e.sta=false;
                          }
                        }
                      });
                    });
                  }
                }
                else if(modo==4)
                {
                  setState(() {
                    g.x=pos.globalPosition.dx;
                    g.y=pos.globalPosition.dy;
                  });
                }
              },
              onDoubleTap: () {
                if(modo==5)
                {
                  vNodo.forEach((element) { element.sta=false;});
                  contf=0;
                  vLineasNuevas.clear();
                  contador=0;
                }
              },
              onPanDown: (ubi) {
                x=ubi.globalPosition.dx;
                y=ubi.globalPosition.dy;
                setState(() {
                  if(modo==1)
                  {
                    vNodo.add(ModeloNodo(ubi.globalPosition.dx,ubi.globalPosition.dy,50,"$cont",false));
                    cont++;
                  }
                });
              },
              onTapDown: (pos) {
                x=pos.globalPosition.dx;
                y=pos.globalPosition.dy;
                if(modo==3)
                  {
                    vNodo.forEach((e) {
                      if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                        {
                          _showDialogEliminar(context, e);
                        }
                    });
                  }
                else if(modo==5)
                {
                  vNodo.forEach((e) {
                    if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                    {
                      e.sta=true;
                      if(contf<1)
                      {
                        g=e;
                      }
                      if(contf<2)
                      {
                        vLineasNuevas.add(ModeloLinea(g, e, ""));
                        vLineas.forEach((element) {
                          if(element.Ni==g && element.Nf==e)
                            {
                              contador=contador+int.parse(element.valor);
                              _showDialogMensaje(context, contador);
                            }
                        });
                        g=e;
                        contf=0;
                      }
                      contf++;
                      setState(() {
                      });
                    }
                  });
                }
              },
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      modo=1;
                      contf=0;
                      vLineasNuevas.clear();
                      contador=0;
                      eliminarBoceto();
                    });
                  },
                  icon: Icon(Icons.add),
                  tooltip: 'Nuevo Nodo',
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    modo=2;
                    contf=0;
                    vLineasNuevas.clear();
                    contador=0;
                    eliminarBoceto();
                  });
                },
                icon: Icon(Icons.flag),
                tooltip: 'Unir Nodo',
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    modo=3;
                    contf=0;
                    vLineasNuevas.clear();
                    contador=0;
                    eliminarBoceto();
                  });
                },
                icon: Icon(Icons.delete),
                tooltip: 'eliminar',
              ),

              IconButton(
                onPressed: (){
                  setState(() {
                    modo=4;
                    contf=0;
                    vLineasNuevas.clear();
                    contador=0;
                    eliminarBoceto();
                  });
                },
                icon: Icon(Icons.drive_file_move_rounded),
                tooltip: 'Mover Nodo',
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    modo=5;
                  });
                },
                icon: Icon(Icons.catching_pokemon),
                tooltip: 'Mover Nodo',
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    modo=-1;
                    vNodo.clear();
                    cont=1;
                    vLineas.clear();
                    contf=0;
                    vLineasNuevas.clear();
                    contador=0;
                    setState(() {
                      eliminarBoceto();
                    });
                  });
                },
                icon: Icon(Icons.delete_forever),
                tooltip: 'Vaciar',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void eliminarLineas(ModeloNodo e)
  {
    vLineas.forEach((element) {
      if(element.Ni==e || element.Nf==e)
      {
          vLineasRemove.add(element);
      }
    });
    vLineas.removeWhere((element) => vLineasRemove.contains(element));
  }

  void eliminarBoceto()
  {
    flagBoceto=false;
    xi=0;
    yi=0;
    xf=0;
    yf=0;
  }
  _showDialogEliminar(context,ModeloNodo e)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("CONFIRMAR ELIMINACIÓN"),
            content: Text("Se eliminará el nodo y sus conexiones."),
            actions: [
              TextButton(onPressed: () {
                eliminarLineas(e);
                vNodo.remove(e);
                setState(() {

                });
                Navigator.of(context).pop();
              }, child: Text("OK")),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")
              ),
            ],
          );
        });
  }
  _showDialogMensaje(context,int valor)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("VALOR"),
            content: Text(valor.toString()),
            actions: [
              TextButton(
                  onPressed: (){
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")
              ),
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
  _showDialog(context, ModeloNodo e)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("INTRODUZCA UN VALOR"),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: ted1,
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    ModeloLinea h=ModeloLinea(g,e,ted1.text);
                    vLineas.add(h);
                    e.sta=false;
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")
              ),
              TextButton(
                  onPressed: (){
                    e.sta=false;
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
  bool verificaConexion(ModeloNodo e)
  {
    bool result=false;
    vLineas.forEach((element) {
      if((element.Ni==g && element.Nf==e)||(element.Ni==e && element.Nf==g))
      {
        k=element;
        result=true;
      }
    });
    return result;
  }
  _showDialogCambio(context, ModeloNodo e,ModeloLinea h)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("CAMBIE EL VALOR"),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: ted1,
            ),
            actions: [
              TextButton(
                  onPressed: (){

                    h.valor=ted1.text;
                    e.sta=false;
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")
              ),
              TextButton(
                  onPressed: (){
                    e.sta=false;
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
}
