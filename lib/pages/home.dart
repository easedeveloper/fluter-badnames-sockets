import 'dart:io';

import 'package:bandname_app/models/bandMoldes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bandsList = [
    Band( id: '1', name: 'Link Park',   votes: 5 ),
    Band( id: '2', name: 'Metallica',   votes: 6 ),
    Band( id: '3', name: 'BabyMetal',   votes: 7 ),
    Band( id: '4', name: 'Los Titanes', votes: 8 ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bandsList.length,

        itemBuilder: (BuildContext context, int index) => _bandTile( bandsList[index] )

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),  
        elevation: 1,
        onPressed: addNewBand
        //addNewBand a esta forma se llama referencia de un metodo 
      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
    //Dismissible, permite deslisar para eliminar el Elemento
      key: Key( band.id! ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( DismissDirection direction ){
        print('DIRECTION: $direction');
        print('ID: ${band.id} ');
        
      },
      background: Container(
        padding: EdgeInsets.only(left: 8),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle( color: Colors.white ))
        ),
      ),

      child: ListTile(
            leading: CircleAvatar(
              child: Text( band.name!.substring(0,2) ),
              backgroundColor: Colors.blue[100],
            ),
            title: Text( band.name! ),
            trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20 ),),
            onTap: (){
              print(band.name);
            },
          ),
    );
  }

  addNewBand(){
    final TextEditingController textEditCrtl = new TextEditingController();
    //Con TextEditingController, obtenemos el texto que se escibr en la caja de texto

    //SI ESTAMOS EN ANDROID MOSTRARA EL DISEÑO DE ANDROID
    if( Platform.isAndroid ){
      return showDialog(
      //SI SE EJECUTA ESTA PARTE DEL CODIGO YA NO QUIERO CONTINUAR
        context: context,
        builder: ( context ) {
          return AlertDialog(
            title: Text('Agregar Nueva Banda'),
            content: TextField(
              controller: textEditCrtl,
            ),

            actions: [
              MaterialButton(
                child: Text('Agregar'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList( textEditCrtl.text )
                //Enviamos el texto escrito en la caja de texto para condicionar si se Escribio algo
              )
            ],
          );
        },
      );
    }

    //SI ESTAMOS EN IOS MOSTRAR EL DISEÑO EN IOS
    showCupertinoDialog(
      context: context,
      builder: (_){
        return CupertinoAlertDialog(
          title: Text('Agregar Nueva Banda'),
          content: CupertinoTextField(
            controller: textEditCrtl,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Agregar'),
              onPressed: () => addBandToList( textEditCrtl.text )
            ),

            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }
    );
    
  }

  void addBandToList( String name ){
    if( name.length > 1 ){
      //Se puede agregar
      this.bandsList.add( new Band(
        id: DateTime.now().toString(),
        name: name,
        votes: 0

      ));
      setState(() {});
      //Con setState ayudara a redibujar en pantalla
    }
    Navigator.pop(context);
    //Se agrega el dialogo le damos Agregar y se cierra la caja 
  }
}