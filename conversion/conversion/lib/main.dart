import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Convert(),
    );
  }
}

class Convert extends StatefulWidget {
  const Convert({super.key});

  @override
  State<Convert> createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  // Cuántos pesos cuesta 1 dólar / 1 euro (actualízalos cuando quieras)
  static const double copPorDolar = 3165;
  static const double copPorEuro = 3570;

  final TextEditingController pesosController = TextEditingController();
  String dolares = '-';
  String euros = '-';
  String? error;

  @override
  void dispose() {
    pesosController.dispose();
    super.dispose();
  }

  void _convertir() {
    final pesos = double.tryParse(
      pesosController.text.trim().replaceAll(',', '.'),
    );

    if (pesos == null || pesos < 0) {
      setState(() {
        error = 'Ingresa una cantidad válida';
        dolares = '-';
        euros = '-';
      });
      return;
    }

    setState(() {
      error = null;
      dolares = (pesos / copPorDolar).toStringAsFixed(2);
      euros = (pesos / copPorEuro).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversiones'),
        backgroundColor: const Color.fromARGB(255, 235, 80, 186),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: pesosController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Cantidad en pesos (COP)',
                prefixIcon: const Icon(Icons.attach_money),
                errorText: error,
              ),
              onSubmitted: (_) => _convertir(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertir,
              child: const Text('Convertir'),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: const Text('Dólares (USD)'),
                trailing: Text(
                  dolares,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.euro),
                title: const Text('Euros (EUR)'),
                trailing: Text(
                  euros,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}