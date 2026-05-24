import 'package:flutter/material.dart';

class TrabajosActivosScreen extends StatelessWidget {
  const TrabajosActivosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajos Activos'),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.handyman_outlined, size: 64, color: Color(0xFFA1A1AA)),
              const SizedBox(height: 24),
              const Text(
                'No hay trabajos en progreso',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Cuando un cliente acepte tu oferta, el trabajo aparecerá aquí para que puedas darle seguimiento.',
                style: TextStyle(fontSize: 15, color: Color(0xFF71717A)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
