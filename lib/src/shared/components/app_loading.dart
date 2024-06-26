import 'package:flutter/material.dart';
import 'package:fast_location/src/shared/colors/app_colors.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.appPageBackground,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.appPageBackground,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }
}
