import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu drawer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PrincipalScreen(),
    );
  }
}

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Menu') ,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader( 
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.blue)],
                color: Colors.pinkAccent),
              child: Text('Vitacontrol')),


              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                trailing:Icon(Icons.arrow_right_alt)
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuracion'),
                trailing:Icon(Icons.arrow_right_alt)
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Usuarios'),
                trailing:Icon(Icons.arrow_right_alt)
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text('Compras'),
                trailing:Icon(Icons.arrow_right_alt)
              ),
              ListTile(
                leading: Icon(Icons.sell),
                title: Text('Ventas'),
                trailing:Icon(Icons.arrow_right_alt)
              )
          ],

        ),
      ),
      body:Center(child: Text ('Bienvenido a flutter'))
    );
  }
}