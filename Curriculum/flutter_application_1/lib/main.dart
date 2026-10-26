import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Datos personales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PerfilPage(),
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  static const _habilidades = [
    'JavaScript',
    'React',
    'Python',
    'C#',
    'Flutter',
    'Django',
    '.NET',
    'Node',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mi perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Tarjeta(
            child: _Encabezado(
              icono: Icons.person,
              titulo: 'Greisy Garcia',
              subtitulo: 'Bello, Antioquia, Colombia',
            ),
          ),
          const SizedBox(height: 12),
          const _Tarjeta(
            child: Column(
              children: [
                _FilaDato(
                  icono: Icons.cake,
                  etiqueta: 'Fecha de nacimiento',
                  valor: '8 de abril del 2005',
                ),
                SizedBox(height: 16),
                _FilaDato(
                  icono: Icons.phone,
                  etiqueta: 'Número de teléfono',
                  valor: '324185882',
                ),
                SizedBox(height: 16),
                _FilaDato(
                  icono: Icons.house,
                  etiqueta: 'Dirección',
                  valor: 'Calle 21c # 40-31',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Tarjeta(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Encabezado(
                  icono: Icons.book,
                  titulo: 'SENA',
                  subtitulo: 'Tecnóloga en análisis y desarrollo de software',
                ),
                const SizedBox(height: 16),
                Text(
                  'Habilidades',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final h in _habilidades) Chip(label: Text(h)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta base reutilizable (elevación, bordes y padding en un solo lugar).
class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

/// Avatar circular + título + subtítulo.
class _Encabezado extends StatelessWidget {
  const _Encabezado({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(255, 211, 144, 223),
          child: Icon(icono, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitulo),
            ],
          ),
        ),
      ],
    );
  }
}

/// Fila "icono + etiqueta: valor" que no se desborda.
class _FilaDato extends StatelessWidget {
  const _FilaDato({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, color: Colors.pinkAccent),
        const SizedBox(width: 16),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$etiqueta: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: valor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}