import 'dart:io';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bandname_app/models/bandMoldes.dart';
import 'package:bandname_app/services/socket_services.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bandsList = [
    // Band( id: '1', name: 'Link Park',   votes: 5 ),
    // Band( id: '2', name: 'Metallica',   votes: 6 ),
    // Band( id: '3', name: 'BabyMetal',   votes: 7 ),
    // Band( id: '4', name: 'Los Titanes', votes: 8 ),
  ];

  @override
  void initState() {
    
    final socketService = Provider.of<SocketServices>(context, listen: false);

    socketService.getSocket.on('Bandas-Activas', _handleActiveBand);
    super.initState();
  }

  _handleActiveBand( dynamic bandasPayload ){
    //Casteando bandasPayload para almacenar en mi arreglo bandsList
       this.bandsList = ( bandasPayload as List)
        .map((banda) => Band.fromMap( banda ))
        .toList();
        // el .map servira para transfomar cada 1 de los valores internos "e" en listado

        setState(() {});
       //me devuelve un listado y luego una coleccion de mapas
       //print(bandasPayload);
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketServices>(context, listen: false);
    socketService.getSocket.off('Bandas-Activas');
    //Servira para evitar escuchar informacion cuando no lo necesita
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ( socketService.getServerStatus == ServerStatus.Online )
              ? Icon(Icons.check_circle, color: Colors.green[300])
              : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),

      body: Column(
        children: [
          (bandsList.isEmpty)
            ? Text('No Existe Bandas', style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold ),)
            : _showGrafic(),

          Expanded(
          //Es necesario colocar un Expanded para que tome todo el espacio disponible en base a la Column
            child: ListView.builder(
              shrinkWrap: true,
              //Arregla la dimension de toda la pantalla
              itemCount: bandsList.length,
              itemBuilder: (BuildContext context, int index) => _bandTile( bandsList[index] )
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.amberAccent,
        child: Icon( Icons.add ),  
        elevation: 1,
        onPressed: addNewBand
        //addNewBand a esta forma se llama referencia de un metodo 
      ),
   );
  }

  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketServices>(context, listen: false);

    return Dismissible(
    //Dismissible, permite deslisar para eliminar el Elemento
      key: Key( band.id ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( DismissDirection direction ) => 
        socketService.getSocket.emit('delete-band', { 'id': band.id }),
        // print('DIRECTION: $direction');
        // print('ID: ${band.id} ');
      
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
              child: Text( band.name.substring(0,2) ),
              backgroundColor: Colors.blue[100],
            ),
            title: Text( band.name ),
            trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20 ),),
            onTap: () =>
              socketService.getSocket.emit('vote-band', { 'id': band.id }),
              //Cuando yo toque el nombre de la banda en mi servidor debo de recibir su ID
              //print(band.id);
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

    final socketService = Provider.of<SocketServices>(context, listen: false);
    
    if( name.length > 1 ){
      socketService.getSocket.emit('add-band', { 'nname': name});


      //Se puede agregar
      // this.bandsList.add( new Band(
      //   id: DateTime.now().toString(),
      //   name: name,
      //   votes: 0
      // ));
      //setState(() {});
      //Con setState ayudara a redibujar en pantalla
    }
    Navigator.pop(context);
    //Se agrega el dialogo le damos Agregar y se cierra la caja 
  }

  //***MOSTRAR LAS GRAFICAS
  Widget _showGrafic(){

    Map<String, double> dataMap = new Map();
    //dataMap.putIfAbsent("Flutter", () => 5);

    bandsList.forEach(( banda ) {
      dataMap.putIfAbsent(banda.name, () => banda.votes.toDouble());
    });

    // final List<Color> colorList = [
    //   Colors.blue,
    //   Colors.red,
    //   Colors.green,
    // ];
    
    
    return Container(
      width: double.infinity,
      height: 200,
      //color: Colors.black,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) { 
          return PieChart(dataMap: dataMap);
         },
        // item: PieChart(
        //   dataMap: dataMap,
        //   // animationDuration: Duration(milliseconds: 800),
        //   // chartLegendSpacing: 32.0,
        //   // chartRadius: MediaQuery.of(context).size.width / 2.7,
        //   // showChartValuesInPercentage: true,
        //   // showChartValues: true,
        //   // showChartValuesOutside: false,
        //   // chartValueBackgroundColor: Colors.grey[200],
        //   // colorList: colorList,
        //   // showLegends: true,
        //   // legendPosition: LegendPosition.right,
        //   // decimalPlaces: 1,
        //   // showChartValueLabel: true,
        //   // initialAngle: 0,
        //   // chartValueStyle: defaultChartValueStyle.copyWith(
        //   //   color: Colors.blueGrey[900].withOpacity(0.9),
        //   // ),
        //   // chartType: ChartType.disc,
        // ), 
      )
    );

  }

}