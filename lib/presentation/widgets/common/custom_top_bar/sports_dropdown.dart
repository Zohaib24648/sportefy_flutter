import 'package:flutter/material.dart';

class SportsDropdown extends StatefulWidget {
  const SportsDropdown({super.key});

  @override
  State<SportsDropdown> createState() => _SportsDropdownState();
}

class _SportsDropdownState extends State<SportsDropdown> {
  final List<_SportOption> _sports = const [
    _SportOption(name: 'Football', iconPath: 'assets/icons/football.png'),
    _SportOption(name: 'Cricket', iconPath: 'assets/icons/cricket_ball.png'),
    _SportOption(name: 'Basketball', iconPath: 'assets/icons/basketball.png'),
  ];
  void _showSportsSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _sports.length,
            shrinkWrap: true,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final sport = _sports[index];
              return ListTile(
                leading: Image.asset(sport.iconPath, width: 28, height: 28),
                title: Text(sport.name),
                onTap: () {
                  Navigator.pop(context);
                  // handle selection logic here
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSportsSheet,
      child: Container(
        height: 50,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/icons/football.png', width: 24, height: 24),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}

class _SportOption {
  final String name;
  final String iconPath;
  const _SportOption({required this.name, required this.iconPath});
}
