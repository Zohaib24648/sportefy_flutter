import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/qr_check_in/qr_screen_bloc.dart';
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
  final Map<int, Widget> _screenCache = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initializeScreens();
  }

  void _initializeScreens() {
    // Pre-build screens that should maintain state
    _screenCache[0] = HomePage(onNavigateToTab: _onNavItemTapped);
    _screenCache[1] = const SearchScreen();
    _screenCache[3] = const ProfileScreen();
    _screenCache[4] = const HistoryScreen();

    // Initialize QR screen if it's the initial screen
    if (_currentIndex == 2) {
      _screenCache[2] = const QRScreen();
    }
    // Note: QR screen (index 2) is not cached and will be built/disposed dynamically
  }

  void _onNavItemTapped(int index) {
    setState(() {
      final previousIndex = _currentIndex;
      _currentIndex = index;

      // Handle QR screen lifecycle
      if (previousIndex == 2 && index != 2) {
        // Disposing QR screen when navigating away from it
        _screenCache.remove(2);
        // Debug: QR Screen disposed - navigated away from scanner
      }

      if (index == 2 && !_screenCache.containsKey(2)) {
        // Creating new QR screen when navigating to it
        _screenCache[2] = const QRScreen();
        // Debug: QR Screen created - navigated to scanner
      }
    });
  }

  Widget _getScreen(int index) {
    return _screenCache[index] ?? const SizedBox.shrink();
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
