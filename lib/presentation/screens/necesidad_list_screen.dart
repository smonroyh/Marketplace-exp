import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/blocs/filtro/filtro_bloc.dart';
import 'package:go_router/go_router.dart';

class NecesidadListScreen extends StatelessWidget {
  final String selectedOficio = 'Todos';
  final String selectedCercania = 'Cerca';

  final List<String> oficios = ['Todos', 'Plomería', 'Electricidad', 'Carpintería'];
  final List<String> cercania = ['Cerca', 'Lejos'];

  final List<Map<String, String>> necesidadesEjemplo = [
    {'titulo': 'Reparar grifo', 'oficio': 'Plomería', 'distancia': 'Cerca'},
    {'titulo': 'Instalación lámpara', 'oficio': 'Electricidad', 'distancia': 'Lejos'},
    {'titulo': 'Armar mueble', 'oficio': 'Carpintería', 'distancia': 'Cerca'},
  ];

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => FiltroBloc()..add(CargarNecesidades(necesidadesEjemplo)),
      child: BlocBuilder<FiltroBloc, FiltroState>(
        builder: (context, state) {
          if (state is !FiltroLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
            title: const Text('Necesidades de Clientes'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: state.oficioSelected,
                          items: oficios.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                          onChanged: (o) {
                            if (o != null) context.read<FiltroBloc>().add(CambiarOficio(o));
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: state.cercaniaSelected,
                          items: cercania.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (c) {
                            if (c != null) context.read<FiltroBloc>().add(CambiarCercania(c));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: (state is FiltroLoaded) ? state.necesidadesFiltradas.length : 0,
                    itemBuilder: (_, i) {
                      final n = (state is FiltroLoaded) ? state.necesidadesFiltradas[i] : null;
                      return ListTile(
                        leading: const Icon(Icons.assignment),
                        title: Text(n!['titulo']!),
                        subtitle: Text('Oficio: ${n['oficio']} - Distancia: ${n['distancia']}'),
                        onTap: () {
                          context.push('/necesidad-detalle', extra: n);
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            
          );
        },
      )
    );
  
  
  }
}

  

