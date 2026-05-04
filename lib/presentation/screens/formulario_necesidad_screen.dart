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
              appBar: AppBar(title: const Text('Publicar necesidad')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    CustomWidgetField(
                      hintText: "Titulo",
                      errorText: state.titulo.displayError,
                      onChanged: (p0) =>
                          context.read<FormNeedBloc>().add(TitleChanged(p0)),
                    ),
                    const SizedBox(height: 12),
                    CustomWidgetField(
                      hintText: "Descripción",
                      errorText: state.descripcion.displayError,
                      maxLines: 3,
                      onChanged: (p0) => context.read<FormNeedBloc>().add(
                        DescriptionChanged(p0),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomWidgetField(
                      hintText: "Presupuesto",
                      errorText: state.presupuesto.displayError != null
        ? _mapError(state.presupuesto.error)
        : null,
                      onChanged: (p0) => context.read<FormNeedBloc>().add(
                        PresupuestoChanged(double.tryParse(p0) ?? 0),
                      ),
                    ),

                    // const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Categoría',
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

                    const SizedBox(height: 18),

                    Text(
                      'Presupuesto: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'A Negociar',
                      style: TextStyle(color: Colors.orange),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state.isValid
                          ? () {
                              context.read<FormNeedBloc>().add(
                                FormNeedSubmitted(),
                              );
                            }
                          : null,
                      child: const Text('Publicar'),
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
