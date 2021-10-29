import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bandname_app/services/socket_services.dart';
import 'package:bandname_app/pages/status.dart';
import 'package:bandname_app/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => SocketServices())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home':   (_) => HomePage(),
          'status': (_) => SstatusPage(),
        },
      ),
    );
  }
}