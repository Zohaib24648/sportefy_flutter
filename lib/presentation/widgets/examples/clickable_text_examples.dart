//lib/presentation/widgets/examples/clickable_text_examples.dart
import 'package:flutter/material.dart';
import '../clickable_text.dart';

/// Example usage of the ClickableText component
class ClickableTextExamples extends StatelessWidget {
  const ClickableTextExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClickableText Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Navigation Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Navigate to a route
            const ClickableText(
              text: 'Go to Settings',
              routeName: '/settings',
              showUnderline: true,
            ),

            const SizedBox(height: 8),

            // Navigate with arguments
            const ClickableText(
              text: 'View Profile Details',
              routeName: '/profile',
              routeArguments: {'userId': '123'},
              isBold: true,
              color: Colors.blue,
            ),

            const SizedBox(height: 24),

            const Text(
              'URL Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Open website
            const ClickableText(
              text: 'Visit Flutter.dev',
              url: 'https://flutter.dev',
              showUnderline: true,
              showLoadingOnTap: true,
            ),

            const SizedBox(height: 8),

            // Open email
            const ClickableText(
              text: 'Send us an email',
              url: 'mailto:support@sportefy.com',
              color: Colors.green,
              fontSize: 16,
            ),

            const SizedBox(height: 8),

            // Open phone dialer
            const ClickableText(
              text: 'Call Support: +1 (555) 123-4567',
              url: 'tel:+15551234567',
              color: Colors.orange,
              isBold: true,
            ),

            const SizedBox(height: 24),

            const Text(
              'Custom Action Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Custom onTap action
            ClickableText(
              text: 'Show Dialog',
              onTap: () => _showCustomDialog(context),
              color: Colors.purple,
              showUnderline: false,
              fontSize: 15,
            ),

            const SizedBox(height: 8),

            // Custom action with loading
            ClickableText(
              text: 'Simulate Loading Action',
              onTap: () => _simulateAsyncAction(context),
              showLoadingOnTap: true,
              color: Colors.red,
              isBold: true,
            ),

            const SizedBox(height: 24),

            const Text(
              'Styled Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Custom text style
            ClickableText(
              text: 'Custom Styled Text',
              url: 'https://github.com',
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.indigo,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),

            const SizedBox(height: 8),

            // Large clickable text
            const ClickableText(
              text: 'Large Link Text',
              url: 'https://dart.dev',
              fontSize: 22,
              isBold: true,
              color: Colors.teal,
              showUnderline: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Action'),
        content: const Text(
          'This is a custom action triggered by ClickableText!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _simulateAsyncAction(BuildContext context) async {
    // Simulate some async work
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Async action completed!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
