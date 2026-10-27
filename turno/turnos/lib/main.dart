// Importamos la biblioteca de Flutter que contiene los componentes
// necesarios para construir la interfaz gráfica de la aplicación.
import 'package:flutter/material.dart';

// Función principal de la aplicación.
// Es el punto de inicio desde el que se ejecuta el programa.
void main() {
  // runApp inicia la aplicación y muestra el widget principal TurnosApp.
  const runAppPlaceholder = 0; // No se utiliza en la ejecución del programa.
  runApp(const TurnosApp());
}

// Constante que almacena el color azul utilizado en diferentes partes
// de la interfaz, como el encabezado y los títulos.
const azul = Color(0xFF123B56);

// Constante que almacena el color verde utilizado para destacar
// botones, iconos y mensajes de confirmación.
const verde = Color(0xFF078C87);

// Clase principal de la aplicación.
// StatelessWidget se utiliza porque esta clase no administra
// directamente datos que cambien durante su funcionamiento.
class TurnosApp extends StatelessWidget {
  // Constructor de la clase. super.key permite recibir una clave
  // que Flutter puede utilizar para identificar el widget.
  const TurnosApp({super.key});

  // build construye y devuelve la interfaz principal de la aplicación.
  @override
  Widget build(BuildContext context) {
    // MaterialApp configura la aplicación con el diseño de Material Design.
    return MaterialApp(
      // Oculta la etiqueta de depuración que aparece en la esquina.
      debugShowCheckedModeBanner: false,

      // Define el nombre de la aplicación.
      title: 'Turnos Johao y Greisy',

      // Configura los colores y el estilo visual general.
      theme: ThemeData(
        // Activa el sistema de diseño Material 3.
        useMaterial3: true,

        // Crea una combinación de colores tomando el verde como base.
        colorScheme: ColorScheme.fromSeed(seedColor: verde),

        // Establece el color de fondo general de las pantallas.
        scaffoldBackgroundColor: const Color(0xFFF2F6F9),
      ),

      // Define la pantalla que se mostrará al iniciar la aplicación.
      home: const PantallaTurnos(),
    );
  }
}

// Clase que representa la información de un paciente.
// Cada objeto Paciente almacena los datos de una persona registrada.
class Paciente {
  // Nombre completo del paciente.
  final String nombre;

  // Número de documento del paciente.
  final String documento;

  // Número de turno asignado al paciente.
  final int turno;

  // Fecha y hora en las que se generó el turno.
  final DateTime fecha;

  // Constructor que permite crear un paciente.
  // required indica que todos estos datos son obligatorios.
  Paciente({
    required this.nombre,
    required this.documento,
    required this.turno,
    required this.fecha,
  });
}

// Pantalla principal del sistema de turnos.
// StatefulWidget permite que la interfaz cambie cuando se registran
// pacientes, se realizan búsquedas o se reinician los datos.
class PantallaTurnos extends StatefulWidget {
  // Constructor de la pantalla.
  const PantallaTurnos({super.key});

  // Crea el estado que administrará los datos y las acciones de la pantalla.
  @override
  State<PantallaTurnos> createState() => _PantallaTurnosState();
}

// Clase que administra el estado y el funcionamiento de la pantalla.
class _PantallaTurnosState extends State<PantallaTurnos> {
  // Controlador que permite leer, modificar y limpiar el campo del nombre.
  final nombreController = TextEditingController();

  // Controlador que permite leer, modificar y limpiar el campo del documento.
  final documentoController = TextEditingController();

  // Controlador que permite leer, modificar y limpiar el campo de búsqueda.
  final busquedaController = TextEditingController();

  // Lista que almacena los pacientes registrados durante la ejecución.
  final List<Paciente> pacientes = [];

  // Número que se asignará al siguiente paciente registrado.
  // Comienza en 1.
  int siguienteTurno = 1;

  // Texto que escribe el usuario en el buscador de pacientes.
  String busqueda = '';

  // Guarda el último paciente registrado para mostrar su comprobante.
  // El símbolo ? permite que inicialmente no haya ningún paciente seleccionado.
  Paciente? ultimoPaciente;

  // Función que imprime en la terminal la información de los pacientes.
  // Sirve para comprobar los registros mientras se ejecuta la aplicación.
  void imprimirListaConsola() {
    // Imprime un encabezado para identificar la lista.
    print('====== LISTA DE PACIENTES ======');

    // Recorre todos los pacientes que están almacenados en la lista.
    for (var paciente in pacientes) {
      // Muestra el número de turno de cada paciente.
      print('Turno: ${paciente.turno}');

      // Muestra el nombre del paciente.
      print('Nombre: ${paciente.nombre}');

      // Muestra el documento del paciente.
      print('Documento: ${paciente.documento}');

      // Imprime una línea para separar los registros.
      print('-------------------------------');
    }

    // Muestra cuántos pacientes hay registrados en total.
    print('Total de pacientes: ${pacientes.length}');
  }

  // Método que se ejecuta cuando se elimina esta pantalla.
  // Libera los recursos utilizados por los controladores de texto.
  @override
  void dispose() {
    // Libera el controlador del campo de nombre.
    nombreController.dispose();

    // Libera el controlador del campo de documento.
    documentoController.dispose();

    // Libera el controlador del campo de búsqueda.
    busquedaController.dispose();

    // Ejecuta la limpieza correspondiente de la clase padre.
    super.dispose();
  }

  // Función que muestra mensajes temporales en la parte inferior
  // de la pantalla, por ejemplo, cuando se genera un turno.
  // El parámetro error permite mostrar mensajes de error en rojo.
  void mensaje(String texto, {bool error = false}) {
    // ScaffoldMessenger administra los mensajes tipo SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Texto que se mostrará al usuario.
        content: Text(texto),

        // Si error es true, el fondo será rojo; de lo contrario, será verde.
        backgroundColor: error ? Colors.red : verde,
      ),
    );
  }

  // Función principal para registrar un paciente y generar su turno.
  void generarTurno() {
    // Obtiene el nombre escrito y elimina espacios al principio y al final.
    final nombre = nombreController.text.trim();

    // Obtiene el documento escrito y elimina espacios sobrantes.
    final documento = documentoController.text.trim();

    // Comprueba que el nombre y el documento no estén vacíos.
    if (nombre.isEmpty || documento.isEmpty) {
      // Informa al usuario que debe completar los campos.
      mensaje('Completa el nombre y el documento.', error: true);

      // Detiene la función para evitar registrar datos incompletos.
      return;
    }

    // Comprueba si ya existe un paciente con el mismo documento.
    if (pacientes.any((p) => p.documento == documento)) {
      // Muestra un mensaje si el documento ya está registrado.
      mensaje('Este documento ya tiene un turno.', error: true);

      // Detiene el registro para evitar documentos duplicados.
      return;
    }

    // Crea un objeto Paciente con los datos ingresados.
    final paciente = Paciente(
      // Guarda el nombre escrito por el usuario.
      nombre: nombre,

      // Guarda el documento escrito por el usuario.
      documento: documento,

      // Asigna el número que corresponde al siguiente turno.
      turno: siguienteTurno,

      // Registra la fecha y la hora actuales.
      fecha: DateTime.now(),
    );

    // setState informa a Flutter que los datos de la pantalla cambiarán
    // y que debe actualizar la interfaz.
    setState(() {
      // Agrega al paciente al principio de la lista.
      pacientes.insert(0, paciente);

      // Guarda al paciente como el último registrado.
      ultimoPaciente = paciente;

      // Aumenta el contador para el siguiente turno.
      siguienteTurno++;

      // Limpia el campo del nombre después del registro.
      nombreController.clear();

      // Limpia el campo del documento después del registro.
      documentoController.clear();
    });

    // Informa que el turno se generó correctamente.
    mensaje('Turno generado correctamente.');

    // Imprime los pacientes registrados en la terminal de VS Code.
    imprimirListaConsola();
  }

  // Función que limpia el formulario y la búsqueda.
  // También oculta el comprobante del último paciente.
  void resetearFormulario() {
    // Actualiza la interfaz después de limpiar los campos.
    setState(() {
      // Limpia el campo del nombre.
      nombreController.clear();

      // Limpia el campo del documento.
      documentoController.clear();

      // Limpia el campo de búsqueda.
      busquedaController.clear();

      // Borra el texto utilizado para filtrar pacientes.
      busqueda = '';

      // Deja de mostrar el comprobante del último paciente.
      ultimoPaciente = null;
    });

    // Informa que el formulario se restableció.
    mensaje('Formulario restablecido correctamente.');
  }

  // Función que permite reiniciar todos los turnos.
  // Antes de eliminar los datos, solicita confirmación al usuario.
  void resetearTodo() {
    // Abre una ventana de diálogo de confirmación.
    showDialog<void>(
      context: context,

      // Construye el contenido de la ventana de confirmación.
      builder: (dialogContext) => AlertDialog(
        // Título de la ventana.
        title: const Text('¿Reiniciar todos los turnos?'),

        // Explica que los pacientes serán eliminados y el contador reiniciado.
        content: const Text(
          'Se eliminarán todos los pacientes y el contador '
          'volverá a 001. ¿Deseas continuar?',
        ),

        // Define los botones disponibles en la ventana.
        actions: [
          // Botón para cancelar la operación.
          TextButton(
            // Cierra el diálogo sin eliminar los datos.
            onPressed: () => Navigator.pop(dialogContext),

            // Texto del botón.
            child: const Text('Cancelar'),
          ),

          // Botón para confirmar el reinicio.
          FilledButton(
            // Define los colores del botón de confirmación.
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),

            // Acciones que se ejecutan al confirmar.
            onPressed: () {
              // Actualiza el estado de la pantalla.
              setState(() {
                // Elimina todos los pacientes de la lista.
                pacientes.clear();

                // Reinicia el contador de turnos a 1.
                siguienteTurno = 1;

                // Oculta el comprobante del último paciente.
                ultimoPaciente = null;

                // Limpia el campo del nombre.
                nombreController.clear();

                // Limpia el campo del documento.
                documentoController.clear();

                // Limpia el campo de búsqueda.
                busquedaController.clear();

                // Borra el filtro de búsqueda.
                busqueda = '';
              });

              // Cierra la ventana de confirmación.
              Navigator.pop(dialogContext);

              // Informa que el reinicio terminó.
              mensaje('Todos los turnos se reiniciaron.');
            },

            // Texto del botón de confirmación.
            child: const Text('Sí, resetear todo'),
          ),
        ],
      ),
    );
  }

  // Función que convierte una fecha en un texto legible.
  // Recibe un objeto DateTime y devuelve día, mes, año, hora y minutos.
  String fechaTexto(DateTime fecha) {
    // Obtiene el día y agrega un cero a la izquierda si es necesario.
    final d = fecha.day.toString().padLeft(2, '0');

    // Obtiene el mes y agrega un cero a la izquierda si es necesario.
    final m = fecha.month.toString().padLeft(2, '0');

    // Obtiene la hora y agrega un cero a la izquierda si es necesario.
    final h = fecha.hour.toString().padLeft(2, '0');

    // Obtiene los minutos y agrega un cero a la izquierda si es necesario.
    final min = fecha.minute.toString().padLeft(2, '0');

    // Devuelve la fecha y la hora en un formato fácil de leer.
    return '$d/$m/${fecha.year} $h:$min';
  }

  // Método encargado de construir la interfaz principal de la pantalla.
  @override
  Widget build(BuildContext context) {
    // Obtiene el ancho disponible de la pantalla en píxeles lógicos.
    final ancho = MediaQuery.of(context).size.width;

    // Scaffold proporciona la estructura general de la pantalla.
    return Scaffold(
      // SafeArea evita que el contenido quede debajo de zonas del sistema.
      body: SafeArea(
        // Column organiza los elementos principales verticalmente.
        child: Column(
          children: [
            // Encabezado superior de la aplicación.
            Container(
              // Hace que el encabezado ocupe todo el ancho disponible.
              width: double.infinity,

              // Agrega espacio interno alrededor del contenido.
              padding: const EdgeInsets.all(22),

              // Aplica el color azul al encabezado.
              color: azul,

              // Row organiza los elementos del encabezado horizontalmente.
              child: const Row(
                children: [
                  // Icono de hospital ubicado al inicio del encabezado.
                  Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                    size: 42,
                  ),

                  // Espacio entre el icono y los textos.
                  SizedBox(width: 15),

                  // Expanded permite que la columna de textos
                  // utilice el espacio horizontal disponible.
                  Expanded(
                    child: Column(
                      // Alinea los textos hacia la izquierda.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título principal de la aplicación.
                        Text(
                          'TURNOS JOHAO Y GREISY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Espacio entre el título y el subtítulo.
                        SizedBox(height: 5),

                        // Descripción de la aplicación.
                        Text(
                          'Sistema de atención al paciente',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // Icono relacionado con la seguridad y la salud.
                  Icon(
                    Icons.health_and_safety,
                    color: Colors.white,
                    size: 34,
                  ),
                ],
              ),
            ),

            // Expanded ocupa el espacio disponible entre el encabezado
            // y el pie de página.
            Expanded(
              // Si el ancho es de 750 o más, organiza el contenido en filas.
              child: ancho >= 750
                  ? Row(
                      children: [
                        // Panel lateral con la lista de pacientes.
                        SizedBox(
                          width: 320,
                          child: panelPacientes(),
                        ),

                        // Área principal que contiene el formulario.
                        Expanded(
                          child: SingleChildScrollView(
                            // Espacio alrededor del formulario.
                            padding: const EdgeInsets.all(28),

                            // Muestra el formulario de registro.
                            child: formulario(),
                          ),
                        ),
                      ],
                    )

                  // Si la pantalla es más estrecha, organiza los paneles
                  // verticalmente para adaptarse al tamaño disponible.
                  : ListView(
                      // Espacio alrededor del contenido en pantallas pequeñas.
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Panel de pacientes con una altura definida.
                        SizedBox(height: 300, child: panelPacientes()),

                        // Espacio entre la lista y el formulario.
                        const SizedBox(height: 20),

                        // Formulario de registro debajo de la lista.
                        formulario(),
                      ],
                    ),
            ),

            // Pie de página ubicado en la parte inferior.
            Container(
              // Ocupa todo el ancho disponible.
              width: double.infinity,

              // Usa el mismo color azul del encabezado.
              color: azul,

              // Espacio interno del pie de página.
              padding: const EdgeInsets.all(12),

              // Texto informativo del pie de página.
              child: const Text(
                'Turnos Johao y Greisy | Atención al paciente',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función que construye el panel lateral de pacientes registrados.
  // También filtra la lista según el texto ingresado en el buscador.
  Widget panelPacientes() {
    // Crea una lista con los pacientes que coinciden con la búsqueda.
    final filtrados = pacientes.where((p) {
      // Convierte el texto de búsqueda a minúsculas.
      final texto = busqueda.toLowerCase();

      // Incluye pacientes cuyo nombre, documento o número de turno
      // contenga el texto que escribió el usuario.
      return p.nombre.toLowerCase().contains(texto) ||
          p.documento.toLowerCase().contains(texto) ||
          p.turno.toString().contains(texto);
    }).toList();

    // Contenedor blanco que agrupa todos los elementos del panel.
    return Container(
      color: Colors.white,

      // Agrega espacio interno alrededor del contenido.
      padding: const EdgeInsets.all(18),

      // Organiza verticalmente los componentes del panel.
      child: Column(
        children: [
          // Fila superior con el título y el total de pacientes.
          Row(
            children: [
              // Icono que representa a un grupo de personas.
              const Icon(Icons.groups, color: verde, size: 28),

              // Espacio entre el icono y el título.
              const SizedBox(width: 8),

              // Permite que el título use el espacio disponible.
              const Expanded(
                child: Text(
                  'Pacientes registrados',
                  style: TextStyle(
                    color: azul,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Círculo que muestra la cantidad total de pacientes.
              CircleAvatar(
                backgroundColor: const Color(0xFFDDF3EF),
                child: Text(
                  // Muestra la cantidad de elementos de la lista.
                  '${pacientes.length}',
                  style: const TextStyle(color: verde),
                ),
              ),
            ],
          ),

          // Espacio entre el encabezado y el buscador.
          const SizedBox(height: 15),

          // Campo de texto que permite buscar pacientes.
          TextField(
            // Conecta el campo con su controlador.
            controller: busquedaController,

            // Configura el aspecto del campo de búsqueda.
            decoration: const InputDecoration(
              hintText: 'Buscar paciente...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),

            // Actualiza el texto de búsqueda cada vez que cambia.
            onChanged: (valor) => setState(() => busqueda = valor),
          ),

          // Espacio entre el buscador y los resultados.
          const SizedBox(height: 12),

          // Expanded utiliza el espacio restante para mostrar los resultados.
          Expanded(
            // Si no hay coincidencias, muestra un mensaje.
            child: filtrados.isEmpty
                ? const Center(
                    child: Text(
                      'No hay pacientes registrados',
                      textAlign: TextAlign.center,
                    ),
                  )

                // Si hay coincidencias, crea una lista desplazable.
                : ListView.builder(
                    // Define la cantidad de elementos que se mostrarán.
                    itemCount: filtrados.length,

                    // Construye cada elemento de la lista.
                    itemBuilder: (context, index) {
                      // Obtiene el paciente correspondiente a la posición.
                      final p = filtrados[index];

                      // Card muestra los datos dentro de una tarjeta.
                      return Card(
                        // ListTile organiza icono, nombre y datos del paciente.
                        child: ListTile(
                          // Icono circular que representa al paciente.
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),

                          // Muestra el nombre del paciente en negrita.
                          title: Text(
                            p.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Muestra el documento y el número del turno.
                          subtitle: Text(
                            'Documento: ${p.documento}\n'
                            'Turno: ${p.turno.toString().padLeft(3, '0')}',
                          ),

                          // Indica que el subtítulo ocupa varias líneas.
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Función que construye el formulario de registro de pacientes.
  // Incluye los campos de entrada, el botón para generar turnos
  // y el espacio donde se muestra el comprobante.
  Widget formulario() {
    // Organiza los elementos del formulario verticalmente.
    return Column(
      // Alinea los elementos hacia la izquierda.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección de registro.
        const Text(
          'Registro de pacientes',
          style: TextStyle(
            color: azul,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Espacio debajo del título.
        const SizedBox(height: 8),

        // Explicación del propósito del formulario.
        const Text(
          'Ingresa los datos para generar un turno de atención.',
          style: TextStyle(color: Colors.blueGrey),
        ),

        // Espacio antes de la tarjeta del formulario.
        const SizedBox(height: 22),

        // Tarjeta blanca que contiene los campos de registro.
        Card(
          color: Colors.white,

          // Padding agrega espacio interno dentro de la tarjeta.
          child: Padding(
            padding: const EdgeInsets.all(22),

            // Organiza los campos y el botón verticalmente.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Etiqueta del campo del documento.
                const Text(
                  'Documento',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                // Espacio entre la etiqueta y el campo.
                const SizedBox(height: 8),

                // Campo donde se ingresa el documento del paciente.
                TextField(
                  // Conecta el campo con su controlador.
                  controller: documentoController,

                  // Configura el texto de ayuda, el icono y el borde.
                  decoration: const InputDecoration(
                    hintText: 'Número de documento',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),

                // Espacio entre el documento y el nombre.
                const SizedBox(height: 20),

                // Etiqueta del campo del nombre completo.
                const Text(
                  'Nombre completo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                // Espacio entre la etiqueta y el campo.
                const SizedBox(height: 8),

                // Campo donde se escribe el nombre del paciente.
                TextField(
                  // Conecta el campo con su controlador.
                  controller: nombreController,

                  // Facilita escribir nombres con iniciales en mayúscula.
                  textCapitalization: TextCapitalization.words,

                  // Configura el texto de ayuda, el icono y el borde.
                  decoration: const InputDecoration(
                    hintText: 'Nombre del paciente',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),

                  // Permite generar el turno al enviar el campo con el teclado.
                  onSubmitted: (_) => generarTurno(),
                ),

                // Espacio antes del botón de registro.
                const SizedBox(height: 24),

                // Contenedor que establece el tamaño del botón.
                SizedBox(
                  // Hace que el botón ocupe todo el ancho disponible.
                  width: double.infinity,

                  // Define la altura del botón.
                  height: 52,

                  // Botón que ejecuta la generación del turno.
                  child: FilledButton.icon(
                    // Llama a generarTurno cuando el usuario presiona el botón.
                    onPressed: generarTurno,

                    // Icono del botón.
                    icon: const Icon(Icons.confirmation_number),

                    // Texto que aparece en el botón.
                    label: const Text(
                      'GENERAR TURNO',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    // Colores del botón.
                    style: FilledButton.styleFrom(
                      backgroundColor: verde,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Espacio entre el formulario y el comprobante.
        const SizedBox(height: 22),

        // Si existe un último paciente, muestra su comprobante.
        if (ultimoPaciente != null)
          comprobante(ultimoPaciente!)

        // Si todavía no hay un paciente registrado, muestra una tarjeta vacía.
        else
          const Card(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Center(
                child: Column(
                  children: [
                    // Icono que representa un comprobante.
                    Icon(
                      Icons.receipt_long,
                      size: 45,
                      color: verde,
                    ),

                    // Espacio debajo del icono.
                    SizedBox(height: 10),

                    // Mensaje que indica dónde aparecerá el comprobante.
                    Text(
                      'El comprobante aparecerá aquí',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Función que construye el comprobante del paciente registrado.
  // Recibe un objeto Paciente con los datos que debe mostrar.
  Widget comprobante(Paciente p) {
    // Card crea una tarjeta para presentar el comprobante.
    return Card(
      color: Colors.white,

      // Define bordes redondeados y un borde verde.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: verde, width: 1.5),
      ),

      // Agrega espacio interno al comprobante.
      child: Padding(
        padding: const EdgeInsets.all(24),

        // Organiza verticalmente la información del comprobante.
        child: Column(
          children: [
            // Icono que confirma que el turno fue generado.
            const Icon(
              Icons.check_circle,
              color: verde,
              size: 45,
            ),

            // Espacio debajo del icono.
            const SizedBox(height: 8),

            // Título que confirma la generación del turno.
            const Text(
              '¡TURNO GENERADO!',
              style: TextStyle(
                color: verde,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Espacio antes del número de turno.
            const SizedBox(height: 15),

            // Etiqueta que explica qué número se muestra.
            const Text('SU NÚMERO DE TURNO ES'),

            // Número de turno mostrado en un tamaño grande.
            Text(
              // Agrega ceros a la izquierda hasta completar tres caracteres.
              p.turno.toString().padLeft(3, '0'),
              style: const TextStyle(
                fontSize: 68,
                fontWeight: FontWeight.bold,
                color: verde,
              ),
            ),

            // Línea divisoria entre el número y los datos del paciente.
            const Divider(),

            // Muestra el nombre del paciente.
            fila('Nombre', p.nombre),

            // Muestra el documento del paciente.
            fila('Documento', p.documento),

            // Muestra la fecha y hora de generación del turno.
            fila('Fecha', fechaTexto(p.fecha)),

            // Espacio antes del mensaje final.
            const SizedBox(height: 15),

            // Mensaje de agradecimiento.
            const Text(
              'Gracias por confiar en nosotros.',
              textAlign: TextAlign.center,
            ),

            // Espacio antes del botón de impresión.
            const SizedBox(height: 15),

            // Botón que muestra un mensaje con la indicación de impresión.
            SizedBox(
              // Hace que el botón ocupe todo el ancho disponible.
              width: double.infinity,

              // Botón para imprimir el comprobante.
              child: OutlinedButton.icon(
                // Al presionarlo, muestra las instrucciones de impresión.
                onPressed: () {
                  mensaje(
                    'Usa Ctrl + P en Chrome para imprimir la página.',
                  );
                },

                // Icono de impresión.
                icon: const Icon(Icons.print),

                // Texto del botón.
                label: const Text('IMPRIMIR COMPROBANTE'),
              ),
            ),

            // Botón que oculta el comprobante para registrar otro paciente.
            TextButton.icon(
              // Actualiza el estado y elimina la referencia al último paciente.
              onPressed: () => setState(() => ultimoPaciente = null),

              // Icono para agregar otro registro.
              icon: const Icon(Icons.add),

              // Texto del botón.
              label: const Text('Registrar otro paciente'),
            ),
          ],
        ),
      ),
    );
  }

  // Función reutilizable que muestra una fila con un título y su valor.
  // Por ejemplo: Nombre: Juan Pérez.
  Widget fila(String titulo, String valor) {
    // Padding agrega espacio vertical entre las filas.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),

      // Row organiza el título y el valor horizontalmente.
      child: Row(
        // Alinea los elementos en la parte superior si ocupan varias líneas.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reserva un ancho fijo para el título.
          SizedBox(
            width: 95,

            // Muestra el título seguido de dos puntos.
            child: Text(
              '$titulo:',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Permite que el valor ocupe el espacio horizontal restante.
          Expanded(
            // SelectableText permite seleccionar y copiar el valor mostrado.
            child: SelectableText(
              valor,
              style: const TextStyle(
                color: azul,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}