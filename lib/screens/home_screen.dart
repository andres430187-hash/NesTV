import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/xtream_api_service.dart';
import '../theme/nesh_theme.dart';

class HomeScreen extends StatefulWidget {
  final NeshUser user;
  const HomeScreen({super.key, required this.user});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  NeshContentType get _currentType => switch (_currentTab) {
        0 => NeshContentType.live,
        1 => NeshContentType.vod,
        _ => NeshContentType.series,
      };

  late final Future<List<NeshCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = XtreamApiService()
        .getCategories(widget.user, _currentType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nesh',
            style: TextStyle(
                color: NeshColors.neon,
                fontWeight: FontWeight.w800,
                letterSpacing: 2)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(widget.user.username,
                  style: const TextStyle(color: NeshColors.textSecondary)),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<NeshCategory>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: NeshColors.neon));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: NeshColors.error)));
          }
          final categories = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                childAspectRatio: 2.2),
            itemCount: categories.length,
            itemBuilder: (_, i) => _CategoryCard(category: categories[i]),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.live_tv), label: 'En Vivo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.movie), label: 'Películas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.tv), label: 'Series'),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final NeshCategory category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeshColors.neon.withOpacity(0.25)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.folder, color: NeshColors.neon, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(category.categoryName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
