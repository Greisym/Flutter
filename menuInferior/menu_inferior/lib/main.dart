import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget es la raíz de la aplicación.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu Inferior',
      home: MenuInferior(),
    );
  }
}

class MenuInferior extends StatefulWidget {
  const MenuInferior({super.key});

  @override
  State<MenuInferior> createState() => _MenuInferiorState();
}

class _MenuInferiorState extends State<MenuInferior> {
  // Guarda la opción seleccionada del menú.
  int indiceSeleccionado = 0;

  final List<Widget> pantallas = [
    Center(
       child: Text('Bienvenido al inicio', 
       style: TextStyle(fontSize: 24))
       ),
    Center(
      child: Text(
        'Bienvenido a configuración ',
        style: TextStyle(fontSize: 24),
      ),
    ),
    Center(
      child: Text(
        'Bienvenido a mi hoja de vida',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Microsoft 3312818')),

      // Menú de navegación inferior.
      body:pantallas[indiceSeleccionado],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.pink,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined),
            label: 'Hoja de vida',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],

        currentIndex:
            indiceSeleccionado, // Detecta qué opción selecciona el usuario.
        onTap: (indice) {
          setState(() {
            indiceSeleccionado = indice;
          });
        },
      ),
    );
  }
}
