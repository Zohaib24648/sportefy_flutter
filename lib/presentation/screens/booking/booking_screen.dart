import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportefy/bloc/slot/slot_bloc.dart';
import 'package:sportefy/dependency_injection.dart';
import 'package:sportefy/presentation/widgets/common/circular_icon_button.dart';
import 'package:sportefy/presentation/widgets/common/primary_button.dart';
import '../../widgets/booking/reusable_widgets.dart';
import '../../widgets/booking/timeslot_chip.dart';
import '../../widgets/common/shimmer_exports.dart';

class BookingScreen extends StatefulWidget {
  final String? venueId;
  final String? venueName;

  const BookingScreen({super.key, this.venueId, this.venueName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SlotBloc>(),
      child: BookingScreenContent(
        venueId: widget.venueId,
        venueName: widget.venueName,
      ),
    );
  }
}

class BookingScreenContent extends StatefulWidget {
  final String? venueId;
  final String? venueName;

  const BookingScreenContent({super.key, this.venueId, this.venueName});

  @override
  State<BookingScreenContent> createState() => _BookingScreenContentState();
}

class _BookingScreenContentState extends State<BookingScreenContent> {
  int selectedDayIndex = 0;
  int? selectedTimeSlotIndex;
  bool isPublic = true;
  late DateTime currentMonth;
  late List<DateTime> currentMonthDays;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
    _generateMonthDays();
    // Load initial slots after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SlotBloc>().add(
        LoadVenueSlots(
          venueId: widget.venueId ?? '0e3912a2-75e2-4838-9ccc-1d25505ba101',
          date: currentMonthDays[selectedDayIndex],
        ),
      );
    });
  }

  void _generateMonthDays() {
    final lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;

    currentMonthDays = List.generate(daysInMonth, (i) {
      return DateTime(currentMonth.year, currentMonth.month, i + 1);
    });

    // Set selected day to today if current month, otherwise first day
    final today = DateTime.now();
    if (currentMonth.year == today.year && currentMonth.month == today.month) {
      selectedDayIndex = today.day - 1;
    } else {
      selectedDayIndex = 0;
    }
  }

  void _navigateMonth(bool isNext) {
    setState(() {
      if (isNext) {
        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
      } else {
        currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
      }
      _generateMonthDays();
      selectedTimeSlotIndex = null;
    });

    // Load slots for new month
    context.read<SlotBloc>().add(
      LoadVenueSlots(
        venueId: widget.venueId ?? '0e3912a2-75e2-4838-9ccc-1d25505ba101',
        date: currentMonthDays[selectedDayIndex],
      ),
    );
  }

  String _getMonthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderImageContainer(
                imageUrl:
                    'https://mypadellife.com/cdn/shop/articles/DSC02009.jpg?v=1681466429',
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: MonthCaptionRow(
                      month: _getMonthName(currentMonth),
                      year: currentMonth.year,
                      onPrev: () => _navigateMonth(false),
                      onNext: () => _navigateMonth(true),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DatePickerStrip(
                      days: currentMonthDays,
                      selectedIndex: selectedDayIndex,
                      onSelect: (i) {
                        setState(() {
                          selectedDayIndex = i;
                          selectedTimeSlotIndex = null;
                        });
                        // Load slots for new date
                        context.read<SlotBloc>().add(
                          LoadVenueSlots(
                            venueId:
                                widget.venueId ??
                                '0e3912a2-75e2-4838-9ccc-1d25505ba101',
                            date: currentMonthDays[i],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const SectionHeader(
                      title: 'Available Time Slots',
                      subtitle:
                          "Select your preferred time slot from the options below. We've made it easy for you to find and book the perfect time for your activity.",
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<SlotBloc, SlotState>(
                      builder: (context, state) {
                        if (state is SlotLoading) {
                          return _buildSlotShimmer();
                        } else if (state is SlotLoaded) {
                          return _buildTimeSlots(state.timeSlots);
                        } else if (state is SlotError) {
                          return _buildErrorState(state.message);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 30),
                    const SectionHeader(
                      title: 'Choose Private or Public Ground Booking',
                      subtitle:
                          'Book privately for your group or publicly to let others join and enjoy the game with you.',
                    ),
                    const SizedBox(height: 12),
                    OptionCard(
                      label: 'Private',
                      icon: const CircleAvatar(
                        radius: 19,
                        backgroundColor: AppColors.background,
                      ),
                      isSelected: !isPublic,
                      onTap: () => setState(() => isPublic = false),
                    ),
                    const SizedBox(height: 12),
                    OptionCard(
                      label: 'Public',
                      icon: const CircleAvatar(
                        radius: 19,
                        backgroundColor: AppColors.background,
                      ),
                      isSelected: isPublic,
                      onTap: () => setState(() => isPublic = true),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionHeader(title: 'Selected gender & age'),
                        CircularIconButton(icon: Icons.edit, onTap: () {}),
                      ],
                    ),
                    const SizedBox(height: 13),
                    const InfoCard(
                      rows: [
                        InfoRow(label: 'Gender:', value: 'Male'),
                        InfoRow(label: 'Age Group:', value: '10 yr to 15yr'),
                      ],
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: 'Proceed Now',
                      onPressed: selectedTimeSlotIndex != null ? () {} : null,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots(List<dynamic> timeSlots) {
    if (timeSlots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No available time slots for this date',
            style: TextStyle(color: AppColors.textMedium, fontFamily: 'Lexend'),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: timeSlots.asMap().entries.map((entry) {
        final index = entry.key;
        final timeSlot = entry.value;

        return TimeSlotChip(
          timeSlot: timeSlot,
          isSelected: selectedTimeSlotIndex == index,
          onTap: () {
            setState(() {
              selectedTimeSlotIndex = index;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSlotShimmer() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        4,
        (index) => AppShimmer(
          child: Container(
            width: 140,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          Text(
            'Failed to load time slots',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontFamily: 'Lexend',
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<SlotBloc>().add(
                RefreshSlots(
                  venueId:
                      widget.venueId ?? '0e3912a2-75e2-4838-9ccc-1d25505ba101',
                  date: currentMonthDays[selectedDayIndex],
                ),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
