# Bottom Navigation Bar Integration

## Overview
This document describes the implementation of the bottom navigation bar integration in the Sportefy Flutter app.

## Architecture

### Main Navigation Wrapper (`lib/presentation/navigation/main_navigation_wrapper.dart`)
- Central navigation controller that manages tab switching
- Uses `IndexedStack` to maintain state across tabs
- Handles navigation between different screens via the bottom navigation bar

### Bottom Navigation Bar (`lib/presentation/widgets/bottom_navigation_bar.dart`)
- Custom designed bottom navigation bar with 5 tabs
- Features a prominent center button for adding new content
- Modern design with rounded corners and shadow effects

### Screen Structure
The app now includes the following main screens:

1. **Home Screen** (`lib/presentation/screens/home/home_screen.dart`)
   - Welcome section with user information
   - Quick action cards for navigation
   - User statistics display
   - Interactive cards that navigate to other tabs

2. **Search Screen** (`lib/presentation/screens/search/search_screen.dart`)
   - Placeholder for sports and event search functionality

3. **Add Screen** (`lib/presentation/screens/add/add_screen.dart`)
   - Placeholder for creating new sports activities or events

4. **Profile Screen** (`lib/presentation/screens/profile/profile_screen.dart`)
   - User profile information
   - Settings and app options
   - Logout functionality

5. **History Screen** (`lib/presentation/screens/history/history_screen.dart`)
   - Placeholder for activity history and past events

## Navigation Flow

### Tab Navigation
- Users can navigate between tabs using the bottom navigation bar
- The current tab is highlighted with the primary app color
- State is preserved when switching between tabs using `IndexedStack`

### Quick Actions
- Home screen includes quick action cards
- Tapping these cards navigates to corresponding tabs:
  - "Find Sports" → Search tab (index 1)
  - "Create Event" → Add tab (index 2)
  - "My Profile" → Profile tab (index 3)
  - "Activity Log" → History tab (index 4)

### Authentication Flow
- After successful login, users are redirected to the main navigation wrapper
- The wrapper starts with the Home tab selected (index 0)

## Key Features

### Bottom Navigation Design
- 5-tab layout: Home, Search, Add, Profile, History
- Elevated center button for the "Add" functionality
- Smooth transitions and hover effects
- Consistent with app's purple theme (`#9C86F2`)

### State Management
- Uses `IndexedStack` to maintain screen state
- Preserves scroll positions and form data when switching tabs
- Efficient memory usage by only building visible screens when needed

### Responsive Design
- Adapts to different screen sizes
- Proper spacing and typography scaling
- Material Design principles

## Usage

### Adding New Screens
1. Create the new screen widget in `lib/presentation/screens/[category]/`
2. Add the screen to the `_getScreen()` method in `MainNavigationWrapper`
3. Update the navigation indices if needed

### Customizing Navigation
- Modify the `CustomBottomNavBar` widget to change appearance
- Update the `_onNavItemTapped` method to add custom navigation logic
- Add new quick actions in the home screen by updating the cards section

## Technical Implementation

### Dependencies
- `flutter_bloc` for state management
- Standard Flutter Material components
- Custom widgets for consistent design

### File Structure
```
lib/
├── presentation/
│   ├── navigation/
│   │   └── main_navigation_wrapper.dart
│   ├── screens/
│   │   ├── home/home_screen.dart
│   │   ├── search/search_screen.dart
│   │   ├── add/add_screen.dart
│   │   ├── profile/profile_screen.dart
│   │   └── history/history_screen.dart
│   └── widgets/
│       └── bottom_navigation_bar.dart
```

### Integration Points
- Main app routing in `main.dart`
- Authentication flow redirects to navigation wrapper
- Consistent color scheme using `AppColors`

## Future Enhancements
- Add navigation animations
- Implement deep linking for direct tab access
- Add badge notifications for tabs
- Enhance the center button with more functionality
- Add navigation analytics and tracking
