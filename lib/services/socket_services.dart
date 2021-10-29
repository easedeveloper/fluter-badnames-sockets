import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketServices with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;


  ServerStatus get getServerStatus => this._serverStatus;
  
  IO.Socket get getSocket => this._socket;
  Function get emit => this._socket.emit;



  SocketServices(){
    this._initConfig();
  }

  void _initConfig(){

      // Dart client
    this._socket = IO.io('http://localhost:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.on('connect', (_) {
     //print('connect');
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });
    
    this._socket.on('disconnect', (_){
    this._serverStatus = ServerStatus.Offline;
     notifyListeners();
    //=> print('disconnect'));
    });



  }
}


    //TODO EL CODIGO DE ABAJO ESTA MODO RIGIDO
    // this._socket.on('nuevo-mensaje', ( paylod ) {
    //   print('nuevo-mensaje:');
    //   print('nombre: ' + paylod['nombre']);
    //   print('mensaje: ' + paylod['mensaje']);

    //   print( paylod.containsKey('mensaje2') ? paylod['mensaje2'] : 'No existe Mensaje 2');
    //   //Sirve para evaluar

    // //El paylod viene a ser un mapa  
    // });