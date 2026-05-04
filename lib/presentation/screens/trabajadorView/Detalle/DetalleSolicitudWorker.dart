import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:push_app/entities/solicitudes.dart';
import 'package:push_app/presentation/blocs/postulacionOferta/postulacion_oferta_bloc.dart';
import 'package:push_app/presentation/blocs/profile/profile_bloc.dart';
import 'package:push_app/widgets/solicitudes/solicitudImg_slideshow.dart';
// Importa tus modelos, blocs y el modal que creamos antes
// import 'package:app/models/solicitud.dart';
// import 'package:app/widgets/postularse_modal.dart';

class SolicitudDetailWorkerScreen extends StatelessWidget {
  final Solicitud solicitud;

  const SolicitudDetailWorkerScreen({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<ProfileBloc>().state;
    return BlocProvider(
      create: (context) => PostulacionOfertaBloc()
        ..add(
          CheckForExistentOffers(
            solicitudId: solicitud.id,
            trabajador: profile.usuario!,
          ),
        ),
      child: BlocBuilder<PostulacionOfertaBloc, PostulacionOfertaState>(
        builder: (context, state) {
          return Scaffold(
            // Botón de acción fijo en la parte inferior
            bottomNavigationBar: _buildBottomAction(context, state),
            body: CustomScrollView(
              slivers: [
                // 1. Cabecera con Imagen
                _buildAppBar(context),
      
                // 2. Contenido de la Solicitud
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderInfo(),
                        const Divider(height: 50),
                        _buildDescription(),
                        const SizedBox(height: 45),
                        _buildClientInfo(),
                        const SizedBox(height: 50),
                        _buildBudgetInfo(),
                        // Espacio extra para el botón inferior
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Widgets de Componentes ---

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        // background: solicitud.fotos.isNotEmpty
        //     ? Image.network(solicitud.fotos[0], fit: BoxFit.cover)
        //     : Container(
        //         color: Colors.blueGrey.shade100,
        //         child: const Icon(Icons.image, size: 80, color: Colors.white),
        //       ),
        background: ImgSolicitudSlideshow(),

        //  background: Container(
        //         color: Colors.blueGrey.shade100,
        //         child: const Icon(Icons.image, size: 80, color: Colors.white),
        //       ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              solicitud.categoria.toUpperCase(),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            solicitud.titulo,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
            const SizedBox(width: 5),
            Text(
              "Aquí la dirección del cliente",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Detalles del trabajo",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          solicitud.detalles,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildClientInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 25, child: Icon(Icons.person)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Publicado por:",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                solicitud.clienteId,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.verified, color: Colors.amber, size: 16),
                  SizedBox(width: 5),
                  Text("Cliente verificado"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInfo() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Presupuesto
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Presupuesto',
                  // style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '\$${solicitud.presupuesto?.toStringAsFixed(0)} COP',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Divider(height: 24),

            // Fecha
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Creada el ${_formatDate(solicitud.fechaCreacion)}',
                  // style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Mensaje invitación
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.work_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '¿Te interesa este trabajo? '
                      'Envía tu oferta con tu propuesta y disponibilidad.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildBottomAction(
    BuildContext context,
    PostulacionOfertaState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: !state.alreadySent
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _showPostularseModal(context, state);
              },
              child: Text(
                "ENVIAR MI PROPUESTA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
                "YA HAS ENVIADO UNA PROPUESTA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  void _showPostularseModal(BuildContext context, state) {
    final profile = context.read<ProfileBloc>().state;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),

      // builder: (_) => PostularseModal(solicitudId: solicitud.id, state: state),
      builder: (_) => BlocProvider(
        create: (_) => PostulacionOfertaBloc(),
        child: BlocListener<PostulacionOfertaBloc, PostulacionOfertaState>(
          listener: (context, state) {
            if (state.status == FormzSubmissionStatus.success) {
            Navigator.pop(context); // Cierra el modal
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("¡Oferta enviada con éxito!"),
                backgroundColor: Colors.green,
              ),
            );
          }
          },
          child: PostularseModal(solicitudId: solicitud.id, state: state),
        ),
      ),
    );
  }
}

class PostularseModal extends StatelessWidget {
  final String solicitudId;
  final PostulacionOfertaState state;

  const PostularseModal({
    super.key,
    required this.solicitudId,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(
          context,
        ).viewInsets.bottom, // Ajuste para el teclado
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enviar Oferta",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          // Campo de Monto
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '¿Cuánto cobrarás? (Sugerido: \$)',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => context.read<PostulacionOfertaBloc>().add(
              MontoChanged(double.tryParse(val) ?? 0),
            ),
          ),
          const SizedBox(height: 15),

          // Campo de Mensaje
          TextField(
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Mensaje para el cliente',
              hintText: 'Cuéntale por qué eres el mejor para este trabajo...',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) =>
                context.read<PostulacionOfertaBloc>().add(MensajeChanged(val)),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
              ),
              onPressed: state.status == FormzSubmissionStatus.inProgress
                  ? null
                  : () {
                      // TODO: Obtener UID y Nombre del AuthBloc
                      final profile = context.read<ProfileBloc>().state;

                      context.read<PostulacionOfertaBloc>().add(
                        FormSubmitted(
                          solicitudId: solicitudId,
                          trabajador: profile
                              .usuario!, // Asegúrate de que el usuario no sea nulo antes de usarlo
                        ),
                      );
                    },
              child: state.status == FormzSubmissionStatus.inProgress
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "ENVIAR POSTULACIÓN",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
