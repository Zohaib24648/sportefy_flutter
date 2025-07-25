import 'package:flutter/material.dart';

class SportsDropdown extends StatefulWidget {
  final Function(Sport)? onSportSelected;

  const SportsDropdown({super.key, this.onSportSelected});

  @override
  State<SportsDropdown> createState() => _SportsDropdownState();
}

class _SportsDropdownState extends State<SportsDropdown> {
  final List<Sport> _sports = const [
    Sport('Football', 'assets/icons/football.png'),
    Sport('Cricket', 'assets/icons/cricket_ball.png'),
    Sport('Basketball', 'assets/icons/basketball.png'),
  ];

  Sport _selectedSport = const Sport('Football', 'assets/icons/football.png');

  void _showSportsSheet() {
    showModalBottomSheet<Sport>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => _SportSelectionBottomSheet(
        sports: _sports,
        selectedSport: _selectedSport,
      ),
    ).then((selectedSport) {
      if (selectedSport != null) {
        setState(() {
          _selectedSport = selectedSport;
        });
        widget.onSportSelected?.call(selectedSport);
      }
    });
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
            Image.asset(_selectedSport.iconPath, width: 24, height: 24),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}

class Sport {
  final String name;
  final String iconPath;
  const Sport(this.name, this.iconPath);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sport && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class _SportSelectionBottomSheet extends StatefulWidget {
  final List<Sport> sports;
  final Sport selectedSport;

  const _SportSelectionBottomSheet({
    required this.sports,
    required this.selectedSport,
  });

  @override
  State<_SportSelectionBottomSheet> createState() =>
      _SportSelectionBottomSheetState();
}

class _SportSelectionBottomSheetState
    extends State<_SportSelectionBottomSheet> {
  late Sport _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedSport;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Which sport do you want to play?',
                      style: TextStyle(
                        color: Color(0xFF161320),
                        fontSize: 20,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        height: 1.60,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                itemCount: widget.sports.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final sport = widget.sports[index];
                  return _SportTile(
                    sport: sport,
                    selected: _currentSelection == sport,
                    onTap: () => setState(() => _currentSelection = sport),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      title: 'Cancel',
                      color: Colors.white,
                      textColor: const Color(0xFF9C86F2),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                      title: 'Save',
                      color: const Color(0xFF9C86F2),
                      textColor: Colors.white,
                      onTap: () => Navigator.of(context).pop(_currentSelection),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SportTile extends StatelessWidget {
  final Sport sport;
  final bool selected;
  final VoidCallback onTap;

  const _SportTile({
    required this.sport,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? const Color(0xFF9C86F2)
        : const Color(0xB2212121);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: ShapeDecoration(
          color: const Color(0xFFFAFAFA),
          shape: RoundedRectangleBorder(
            side: selected
                ? const BorderSide(width: 1, color: Color(0xFF9C86F2))
                : BorderSide.none,
            borderRadius: BorderRadius.circular(14),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 24,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF2F6F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      sport.iconPath,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  sport.name,
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 14,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w500,
                    height: 1.60,
                  ),
                ),
              ],
            ),
            Container(
              width: 18,
              height: 18,
              padding: const EdgeInsets.all(3),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: borderColor),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: selected
                  ? Container(
                      decoration: const ShapeDecoration(
                        color: Color(0xFF9C86F2),
                        shape: OvalBorder(),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            side: color == Colors.white
                ? const BorderSide(width: 1, color: Color(0xFF9C86F2))
                : BorderSide.none,
            borderRadius: BorderRadius.circular(14),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x38000000),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}
