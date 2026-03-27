import 'package:flutter/material.dart';
import 'package:taskhub/config/app_colors.dart';
import 'package:taskhub/widgets/app_bar_widget.dart';
import 'package:taskhub/screens/menu/profile_screen.dart';
import 'package:taskhub/screens/menu/home_menu_screen.dart';
import 'package:taskhub/screens/menu/feed_screen.dart';
import 'package:taskhub/screens/menu/requests_screen.dart';
import 'package:taskhub/screens/menu/create_publication_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Home is selected by default

  final List<Widget> _screens = const [
    HomeMenuScreen(),
    FeedScreen(),
    RequestsScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = ['Home', 'Feed', 'Solicitações', 'Perfil'];

  Future<void> _openCreatePublicationScreen() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CreatePublicationScreen()));

    if (!mounted || result == null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Publicação "${result['title']}" criada com sucesso!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskHubAppBar(
        title: _titles[_selectedIndex],
        showBackButton: false,
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: _openCreatePublicationScreen,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Criar publicação'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            activeIcon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Solicitações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
