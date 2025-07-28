import 'package:flutter/material.dart';
import 'package:sportefy/presentation/widgets/booking/day_card.dart';
import 'package:sportefy/presentation/widgets/common/circular_icon_button.dart';

/// Centralised colour palette so visual tweaks stay consistent
class AppColors {
  AppColors._();

  static const background = Color(0xFFF2F6F7);
  static const primary = Color(0xFF9C86F2);
  static const textDark = Color(0xFF1A1D1F);
  static const textMedium = Color(0xFF63616A);
  static const cardShadow = Color(0x0F000000);
}

/// A rounded hero image that can host any overlay children
class HeaderImageContainer extends StatelessWidget {
  const HeaderImageContainer({
    super.key,
    required this.imageUrl,
    this.height = 340,
    this.child,
  });

  final String imageUrl;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: height,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          if (child != null) Positioned.fill(child: child!),
        ],
      ),
    );
  }
}

/// A tiny circular button for back/forward arrows or any small icon tap
/// Month caption flanked by two navigation arrows
class MonthCaptionRow extends StatelessWidget {
  const MonthCaptionRow({
    super.key,
    required this.month,
    required this.year,
    this.onPrev,
    this.onNext,
  });

  final String month;
  final int year;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircularIconButton(icon: Icons.arrow_back_ios_new, onTap: onPrev),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              month,
              style: const TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '($year)',
              style: const TextStyle(fontSize: 12, fontFamily: 'Lexend'),
            ),
          ],
        ),
        CircularIconButton(icon: Icons.arrow_forward_ios, onTap: onNext),
      ],
    );
  }
}

/// Horizontal strip of DayCards; manage selection outside for clarity
class DatePickerStrip extends StatelessWidget {
  const DatePickerStrip({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<DateTime> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 69,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final d = days[idx];
          return DayCard(
            weekday: _weekdayShort(d.weekday),
            day: d.day.toString().padLeft(2, '0'),
            isSelected: idx == selectedIndex,
            onTap: () => onSelect(idx),
          );
        },
      ),
    );
  }

  String _weekdayShort(int weekday) {
    const names = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return names[weekday - 1];
  }
}

/// Title with an optional subtitle beneath
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Lexend',
            color: Color(0xFF272727),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Lexend',
              color: AppColors.textMedium,
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }
}

/// Radio‑style card presenting an option (eg. Private / Public)
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final Widget icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.primary : Colors.transparent;
    final indicatorFill = isSelected ? AppColors.primary : Colors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
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
                icon,
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              width: 18,
              height: 18,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: borderColor == Colors.transparent
                      ? Colors.black.withValues(alpha: 0.5)
                      : borderColor,
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: indicatorFill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bold label on the left, value text on the right
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
            color: Color(0xCC161320),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Lexend',
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }
}

/// Card that groups a list of InfoRows
class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.rows});

  final List<InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var row in rows) ...[row, const SizedBox(height: 9)],
        ],
      ),
    );
  }
}
