import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/blocs/bloc/notifications_bloc.dart';
import 'package:push_app/presentation/blocs/publicaciones/publicaciones_bloc_bloc.dart';
import 'package:push_app/presentation/screens/formulario_necesidad_screen.dart';
import 'package:push_app/presentation/screens/misSolicitudesView.dart';
import 'package:push_app/presentation/screens/perfilClienteScreen.dart';
import 'package:push_app/widgets/publicaciones/publicacionCard.dart';
import 'necesidad_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indexSelected = 0;

  @override
  Widget build(BuildContext context) {
    final blocAuth = context.read<AuthBloc>();

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => PublicacionesBlocBloc()..add(LoadedPublicacionesRequested())),],
      child: Scaffold(
        body: IndexedStack(
          index: _indexSelected,
          children: [
            const _SearchHomeView(),
            const MisSolicitudesView(),
            const PerfilClienteScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF09090B),
          unselectedItemColor: const Color(0xFFA1A1AA),
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Mis Solicitudes'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
          ],
          currentIndex: _indexSelected,
          onTap: (index) {
            setState(() {
              _indexSelected = index;
            });
          },
        ),
      ),
    );
  }
}

class _SearchHomeView extends StatelessWidget {
  const _SearchHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // React Tepo uses white bg
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // --- Header: Ubicación actual y Avatar ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ubicación actual',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF71717A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: const [
                            Text(
                              'Ciudad de México',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF09090B),
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '▾',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF09090B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F5),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE4E4E7)),
                      ),
                      child: const Icon(Icons.person, size: 20, color: Color(0xFF71717A)),
                    ),
                  ],
                ),
              ),
            ),

            // --- Search Bar ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE4E4E7)),
                  ),
                  child: Row(
                    children: const [
                      Text('🔍', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 14, color: Color(0xFF09090B)),
                          decoration: InputDecoration(
                            hintText: 'Buscar servicios...',
                            hintStyle: TextStyle(color: Color(0xFFA1A1AA), fontSize: 14),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- Categories Section ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(
                  height: 88,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildCategoryItem('🔧', 'Plomería'),
                      _buildCategoryItem('⚡', 'Electricidad'),
                      _buildCategoryItem('🧹', 'Limpieza'),
                      _buildCategoryItem('🪚', 'Carpintería'),
                      _buildCategoryItem('🎨', 'Pintura'),
                      _buildCategoryItem('🏡', 'Jardinería'),
                    ],
                  ),
                ),
              ),
            ),

            // --- Servicios Cercanos Section ---
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Servicios Cercanos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF09090B),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Ver todos',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF71717A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 196,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildNearbyCard(
                          'Carlos Gómez',
                          'Plomero experto',
                          '0.8 km',
                          'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?q=80&w=300',
                        ),
                        _buildNearbyCard(
                          'Ana Martínez',
                          'Electricista profesional',
                          '1.5 km',
                          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=300',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Trabajadores Destacados Title ---
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
                child: Text(
                  'Trabajadores Destacados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF09090B),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),

            // --- Trabajadores Destacados List (Real DB data) ---
            BlocBuilder<PublicacionesBlocBloc, PublicacionesBlocState>(
              builder: (context, state) {
                if (state is PublicacionesLoading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF09090B))),
                    ),
                  );
                }
                if (state is PublicacionesLoaded) {
                  if (state.publicaciones.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: Text('No hay servicios disponibles.')),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return PublicacionCard(publicacion: state.publicaciones[index]);
                      },
                      childCount: state.publicaciones.length,
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String icon, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E4E7)),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF09090B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(String name, String role, String distance, String imageUrl) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              width: 140,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 140,
                height: 100,
                color: const Color(0xFFF4F4F5),
                child: const Icon(Icons.person, color: Color(0xFF71717A)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF09090B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF71717A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    distance,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFA1A1AA),
                      fontWeight: FontWeight.w500,
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
}
