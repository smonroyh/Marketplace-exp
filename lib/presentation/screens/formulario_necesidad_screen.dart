import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:push_app/entities/solicitudes.dart';
import 'package:push_app/infraestructure/inputs/presupuesto.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/form/form_need_bloc.dart';
import 'package:push_app/presentation/blocs/solicitudes.dart/solicitudes_bloc.dart';

String? _mapError(PresupuestoError? error) {
  switch (error) {
    case PresupuestoError.empty:
      return 'El presupuesto es requerido';
    case PresupuestoError.invalid:
      return 'Debe ser un número válido';
    case PresupuestoError.tooLow:
      return 'Debe ser mayor a 0';
    default:
      return null;
  }
}

class FormularioNecesidadScreen extends StatelessWidget {
  FormularioNecesidadScreen({super.key});
  final categorias = const [
    'Plomería',
    'Electricidad',
    'Carpintería',
    'Jardinería',
    'Otro',
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FormNeedBloc(),
      child: BlocListener<FormNeedBloc, FormNeedState>(
        listener: (context, state) {
          print("Listen de estado success" + state.status.toString());
          if (state.status.isSuccess){
            context.read<SolicitudesBloc>().add(LoadSolicitudes(
              status: SolicitudStatus.pendiente, 
              clientId: context.read<AuthBloc>().state.userId!));

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Necesidad publicada (envío demo, BLoC + Formz)',
                    ),
                  ),
                );
                Navigator.of(context).pop();
          }
      
        },
        child: BlocBuilder<FormNeedBloc, FormNeedState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Solicitar Servicio'),
                centerTitle: false,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ListView(
                  children: [
                    const Text(
                      '¿En qué podemos ayudarte?',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Describe tu problema para que los profesionales te den un presupuesto.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
                    ),
                    const SizedBox(height: 32),
                    
                    // --- SECCIÓN: Detalles Básicos ---
                    const Text('1. Detalles del problema', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    CustomWidgetField(
                      hintText: "Título (Ej. Fuga de agua en lavabo)",
                      errorText: state.titulo.displayError,
                      onChanged: (p0) =>
                          context.read<FormNeedBloc>().add(TitleChanged(p0)),
                    ),
                    const SizedBox(height: 16),
                    CustomWidgetField(
                      hintText: "Descripción detallada",
                      errorText: state.descripcion.displayError,
                      maxLines: 4,
                      onChanged: (p0) => context.read<FormNeedBloc>().add(
                        DescriptionChanged(p0),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- SECCIÓN: Fotos (MOCKUP) ---
                    const Text('2. Fotos (Opcional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE4E4E7), style: BorderStyle.solid), // Usamos sólido temporalmente en lugar de punteado para no usar paquetes extra
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: Color(0xFFA1A1AA), size: 32),
                            SizedBox(height: 8),
                            Text('Toca para subir fotos', style: TextStyle(color: Color(0xFF71717A))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- SECCIÓN: Presupuesto y Categoría ---
                    const Text('3. Clasificación y Precio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Categoría del servicio',
                        errorText: state.categoria.isNotValid
                            ? state.categoria.error
                            : null,
                      ),
                      value: state.categoria.value.isEmpty
                          ? categorias[0]
                          : state.categoria.value,
                      onChanged: (c) => context.read<FormNeedBloc>().add(
                        CategoriaChanged(c!),
                      ),
                      items: categorias
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    CustomWidgetField(
                      hintText: "Presupuesto estimado (\$)",
                      errorText: state.presupuesto.displayError != null
                          ? _mapError(state.presupuesto.error)
                          : null,
                      onChanged: (p0) => context.read<FormNeedBloc>().add(
                        PresupuestoChanged(double.tryParse(p0) ?? 0),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- SECCIÓN: Ubicación y Tiempo (MOCKUP) ---
                    const Text('4. Ubicación y Horario', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      initialValue: "Mi casa (Av. Principal 123)",
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF71717A)),
                        labelText: "Dirección",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      initialValue: "Lo antes posible",
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.access_time, color: Color(0xFF71717A)),
                        labelText: "Cuándo",
                      ),
                    ),

                    const SizedBox(height: 48),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      onPressed: state.isValid
                          ? () {
                              context.read<FormNeedBloc>().add(
                                FormNeedSubmitted(),
                              );
                            }
                          : null,
                      child: const Text('Publicar Solicitud', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomWidgetField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final String? errorText;
  final int? maxLines;
  const CustomWidgetField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.errorText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(labelText: hintText, errorText: errorText),
      onChanged: onChanged,
    );
  }
}
