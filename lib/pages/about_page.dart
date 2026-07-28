import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: Colors.transparent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 12),
            Text(
              AppConstants.slogan,
              style: TextStyle(
                color: AppColors.textSoft,
                fontSize: 17,
                height: 1.5,
              ),
            ),
            SizedBox(height: 28),
            Text(
              'Una emisora cristiana dedicada a proclamar la sana doctrina '
              'y compartir contenido bíblico las 24 horas.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            Spacer(),
            Center(
              child: Text(
                'Soli Deo Gloria',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
