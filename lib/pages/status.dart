import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bandname_app/services/socket_services.dart';

class SstatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketServices>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${ socketService.getServerStatus }')
          ],
        ),
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon( Icons.message ),
       onPressed: (){
         socketService.emit('emitir-mensaje', { 
           'nombre': 'Flutter',
           'mensaje':'Ingeniero Salas'
        });
       },
     ),
   );
  }
}