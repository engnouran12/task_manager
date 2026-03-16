import 'package:flutter/material.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/features/home/presentation/view/wiget/bottom_bar_admin.dart';
import 'package:task_manager/features/home/presentation/view/wiget/bottom_nav.dart';

class ChooseUserTypeView extends StatelessWidget {
  const ChooseUserTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Select User Type', style: AppStyles.stylebold24(context)),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome! Please select your role to continue:',
              style: AppStyles.styleSemiBold14(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildRoleButton(
              context: context,
              title: 'manger',
              icon: Icons.admin_panel_settings,
              onTap: () {
                role = 'admin';
                id = 'mgr1'; // Mock admin ID
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const BottomNavigationBarAdmin()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildRoleButton(
              context: context,
              title: 'Employee',
              icon: Icons.person,
              onTap: () {
                role = 'employee';
                id = 'e1'; // Mock employee ID
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const BottomNavigationBarUser()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildRoleButton(
              context: context,
              title: 'Supervisor',
              icon: Icons.supervisor_account,
              onTap: () {
                role = 'supervisor';
                id = 'mgr2'; // Mock supervisor/manager ID
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const BottomNavigationBarAdmin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.white, size: 28),
          const SizedBox(width: 15),
          Text(
            title,
            style: AppStyles.styleSemiBold20(context),
          ),
        ],
      ),
    );
  }
}
