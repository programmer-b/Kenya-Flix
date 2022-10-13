import 'package:flutter/material.dart';
import 'package:kenyaflix/Fragments/kf_downloads_fragment.dart';
import 'package:kenyaflix/Fragments/kf_home_fragment.dart';
import 'package:kenyaflix/Fragments/kf_trailers_and_more_fragment.dart';

class KFHomeScreen extends StatefulWidget {
  const KFHomeScreen({Key? key}) : super(key: key);

  @override
  State<KFHomeScreen> createState() => _KFHomeScreenState();
}

class _KFHomeScreenState extends State<KFHomeScreen> {
  static int _selectedIndex = 0;
  void _onItemTapped(index) => setState(() => _selectedIndex = index);
  Widget _selectedFragment(index) {
    switch (index) {
      case 0:
        return const KFHomeFragment();
      case 1:
        return const KFTrailersAndMoreFragment();
      case 2:
        return const KFDownloadsFragment();
      default:
        return const KFHomeFragment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedFragment(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              tooltip: 'Home',
              icon: _selectedIndex == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
              label: 'Home'),
          BottomNavigationBarItem(
              tooltip: 'Trailers',
              icon: _selectedIndex == 1
                  ? const Icon(Icons.video_library)
                  : const Icon(Icons.video_library_outlined),
              label: 'Trailers and More'),
          BottomNavigationBarItem(
              tooltip: 'Downloads',
              icon: _selectedIndex == 2
                  ? const Icon(Icons.file_download_rounded)
                  : const Icon(Icons.file_download_outlined),
              label: 'Downloads'),
        ],
      ),
    );
  }
}
