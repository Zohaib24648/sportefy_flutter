// import 'package:flutter/material.dart';
// import '../../constants/app_colors.dart';
// import '../../widgets/common/shimmer_exports.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       white: AppColors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // App Logo with subtle shimmer effect
//             AppShimmer(
//               baseColor: AppColors.primary.withValues(alpha: 0.8),
//               highlightColor: AppColors.primary.withValues(alpha: 1.0),
//               child: const Text(
//                 'Sportefy',
//                 style: TextStyle(
//                   fontSize: 48,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                   fontFamily: 'Lexend',
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Loading indicator with shimmer
//             AppShimmer(
//               baseColor: AppColors.primary.withValues(alpha: 0.6),
//               highlightColor: AppColors.primary.withValues(alpha: 0.9),
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Loading text with shimmer
//             AppShimmer(
//               baseColor: Colors.grey[400]!,
//               highlightColor: Colors.grey[200]!,
//               child: ShimmerText(
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 height: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
