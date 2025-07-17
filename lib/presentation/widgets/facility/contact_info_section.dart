import 'package:flutter/material.dart';
import 'package:sportefy/data/model/facility_details.dart';

class ContactInfoSection extends StatelessWidget {
  final String phoneNumber;
  final Owner owner;

  const ContactInfoSection({
    super.key,
    required this.phoneNumber,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        _buildContactRow(icon: Icons.phone, text: phoneNumber),
        const SizedBox(height: 8),
        _buildContactRow(
          icon: Icons.person,
          text: 'Owner: ${owner.profile.fullName}',
        ),
      ],
    );
  }

  Widget _buildContactRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9C86F2)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF272727),
            fontSize: 12,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
