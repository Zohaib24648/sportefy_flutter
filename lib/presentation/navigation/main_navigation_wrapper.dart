import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/add/add_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/history/history_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  final int initialIndex;

  const MainNavigationWrapper({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return HomePage(onNavigateToTab: _onNavItemTapped);
      case 1:
        return const SearchScreen();
      case 2:
        return const AddScreen();
      case 3:
        return const ProfileScreen();
      case 4:
        return const HistoryScreen();
      default:
        return HomePage(onNavigateToTab: _onNavItemTapped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(5, (index) => _getScreen(index)),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
