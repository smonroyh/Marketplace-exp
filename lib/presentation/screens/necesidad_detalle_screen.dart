import 'package:flutter/material.dart';

class NecesidadDetalleScreen extends StatelessWidget {
  final Map<String, String> need;

  const NecesidadDetalleScreen({super.key, required this.need});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(need['titulo'] ?? 'Detalle Necesidad')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Oficio: ${need['oficio']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Distancia: ${need['distancia']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Acción ejemplo: contactar, postularse, etc.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función por implementar')),
                );
              },
              icon: const Icon(Icons.contact_phone),
              label: const Text('Contactar'),
            )
          ],
        ),
      ),
    );
  }
}
