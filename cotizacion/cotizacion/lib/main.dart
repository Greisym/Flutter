import 'package:flutter/material.dart';

// Función principal que arranca la aplicación Flutter.
void main() {
  runApp(const MyApp());
}

// Widget principal de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CotizaFácil',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.grey,
        fontFamily: 'Roboto',
      ),
      home: const CotizadorHomePage(),
    );
  }
}

// Widget con estado porque los valores cambiarán al calcular.
class CotizadorHomePage extends StatefulWidget {
  const CotizadorHomePage({super.key});

  @override
  State<CotizadorHomePage> createState() => _CotizadorHomePageState();
}

class _CotizadorHomePageState extends State<CotizadorHomePage> {
  // Controladores para capturar el texto de los campos.
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  // Variables para almacenar los resultados.
  double _totalVenta = 0.0;
  String _resumenProducto = "";
  bool _calculado = false;

  // Método que realiza los cálculos de la cotización.
  void _calcularCotizacion() {
    // Obtenemos los valores ingresados.
    String nombre = _nombreController.text.trim();

    double? precio = double.tryParse(_precioController.text);
    int? cantidad = int.tryParse(_cantidadController.text);

    // Validamos que los datos sean correctos.
    if (nombre.isEmpty ||
        precio == null ||
        precio <= 0 ||
        cantidad == null ||
        cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingresa un producto, un precio y una cantidad válidos.',
          ),
        ),
      );
      return;
    }

    // 1. Calculamos el valor bruto.
    double valorBruto = precio * cantidad;

    // 2. Calculamos el descuento según la cantidad.
    double descuento = 0.0;

    if (cantidad >= 100 && cantidad <= 500) {
      descuento = valorBruto * 0.10;
    } else if (cantidad > 500) {
      descuento = valorBruto * 0.15;
    }

    // 3. Calculamos el IVA del 19 % sobre el valor bruto.
    double iva = valorBruto * 0.19;

    // 4. Calculamos el total final.
    double totalFinal = valorBruto - descuento + iva;

    // 5. Actualizamos los resultados en pantalla.
    setState(() {
      _totalVenta = totalFinal;
      _resumenProducto = "$nombre · $cantidad unidades";
      _calculado = true;
    });
  }

  // Método para formatear los números con puntos de miles.
  String _formatearMoneda(double monto) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]}.';

    return monto.toStringAsFixed(0).replaceAllMapped(reg, mathFunc);
  }

  // Método que personaliza el aspecto de los campos de texto.
  InputDecoration _inputDecoration(String texto) {
    return InputDecoration(
      hintText: texto,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }

  // Liberamos los controladores cuando se cierra la pantalla.
  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SECCIÓN DE ENCABEZADO.
              const Text(
                'CotizaFácil',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Calcula el precio de tu venta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 32),

              // CAMPO: NOMBRE DEL PRODUCTO.
              const Text(
                'Nombre del producto',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _nombreController,
                decoration: _inputDecoration('Ej. Camiseta'),
              ),

              const SizedBox(height: 16),

              // CAMPO: PRECIO UNITARIO.
              const Text(
                'Precio unitario (\$)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _precioController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _inputDecoration('Ej. 35000'),
              ),

              const SizedBox(height: 16),

              // CAMPO: CANTIDAD.
              const Text(
                'Cantidad',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Ej. 3'),
              ),

              const SizedBox(height: 24),

              // BOTÓN PARA CALCULAR LA COTIZACIÓN.
              ElevatedButton(
                onPressed: _calcularCotizacion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Calcular cotización',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // SECCIÓN DE RESULTADOS.
              // Solo aparece después de calcular.
              if (_calculado) ...[
                const Divider(thickness: 1),

                const SizedBox(height: 16),

                const Text(
                  'TOTAL DE LA VENTA',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 24),

                Text(
                  '\$${_formatearMoneda(_totalVenta)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  _resumenProducto,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
