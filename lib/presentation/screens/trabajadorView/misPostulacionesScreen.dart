import 'package:flutter/material.dart';

class MisPostulacionesScreen extends StatelessWidget {
  const MisPostulacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ofertas'),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.assignment_outlined, size: 64, color: Color(0xFFA1A1AA)),
              const SizedBox(height: 24),
              const Text(
                'Aún no has enviado ofertas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Aquí aparecerán las postulaciones que envíes a las solicitudes de los clientes.',
                style: TextStyle(fontSize: 15, color: Color(0xFF71717A)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Mover al feed
                },
                child: const Text('Explorar Trabajos'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
