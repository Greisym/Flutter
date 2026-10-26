
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Convertir(),
    );
  }
}

class Convertir extends StatefulWidget {
  const Convertir({super.key});

  @override
  State<Convertir> createState() => _CalculatorState();
}

class _CalculatorState extends State<Convertir> {
  final TextEditingController pesosController =
      TextEditingController();
  final TextEditingController dolaresController =
      TextEditingController();
  final TextEditingController eurosController =
      TextEditingController();

  String result = '';

  // CORRECCIÓN 1:
  // La función va dentro de _CalculatorState,
  // pero fuera de build() y de onPressed.
  // Recibe los pesos y el precio del dólar.
  double convert(double pesos, double precioDolar) {
    // CORRECCIÓN 2:
    // Dividimos los pesos entre el precio del dólar.
    double convertir = pesos / precioDolar;
    double convertir = pesos / precioEuro;

    // CORRECCIÓN 3:
    // Devolvemos el resultado de la división.
    return convertir;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora Basica'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: pesosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digita los pesos colombianos',
              ),
            ),
            TextField(
              controller: dolaresController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Campo de dólares',
              ),
            ),
            TextField(
              controller: eurosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Campo de euros',
              ),
            ),
            SizedBox(height: 10),
            Text('Resultado = $result'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // CORRECCIÓN 4:
                // Comprobamos que el campo de pesos tenga
                // un número válido antes de convertirlo.
                double? pesos =
                    double.tryParse(pesosController.text);

                if (pesos == null || pesos < 0) {
                  setState(() {
                    result = 'Digita una cantidad válida';
                  });
                  return;
                }

                double precioDolar = 3000;

                // CORRECCIÓN 5:
                // Llamamos a la función y guardamos
                // el número que devuelve.
                double dolares = convert(pesos, precioDolar);

                // CORRECCIÓN 6:
                // Actualizamos el texto que ve el usuario.
                setState(() {
                  result = dolares.toStringAsFixed(2);
                });
              },
              child: Text('Convertir'),
            ),
          ],
        ),
      ),
    );
  }
}
