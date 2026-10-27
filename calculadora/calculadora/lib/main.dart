
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

  // Convierte pesos colombianos a dólares o euros.
  double convert(double pesos, double precioMoneda) {
    double convertir = pesos / precioMoneda;

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
                double? pesos =
                    double.tryParse(pesosController.text);

                if (pesos == null || pesos < 0) {
                  setState(() {
                    result = 'Digita una cantidad válida';
                  });
                  return;
                }

                double precioDolar = 3000;
                double precioEuro = 3500;

                double dolares = convert(pesos, precioDolar);
                double euros = convert(pesos, precioEuro);

                setState(() {
                  result =
                      'Dólares: ${dolares.toStringAsFixed(2)}\n'
                      'Euros: ${euros.toStringAsFixed(2)}';

                  dolaresController.text =
                      dolares.toStringAsFixed(2);
                  eurosController.text =
                      euros.toStringAsFixed(2);
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
