import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget es la raíz de la aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Greisy G',
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
      child: Text('Bienvenida al nuestros Spa', style: TextStyle(fontSize: 24)),
    ),
    Center(
      child: Text('Maquillate con nosotros', style: TextStyle(fontSize: 24)),
    ),
    Center(
      child: Text('Agenda tu cita de manicura', style: TextStyle(fontSize: 24)),
    ),
    Center(
      child: Text(
        'Cambia tu look con nosotros',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenidos a mi tienda ')),

      // Menú de navegación inferior.
      body: pantallas[indiceSeleccionado],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 246, 154, 185),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.spa, color: Colors.white),
            label: 'Spa',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.clean_hands, color: Colors.white),
            label: 'Maquillaje', backgroundColor: Colors.white,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.brush, color: Colors.white),
            label: 'Manicuras',backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_cut, color: Colors.white),
            label: 'Peluqueria',
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
