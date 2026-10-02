import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'add_edit_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Wallet Illustration
              Center(
                child: SizedBox(
                  width: 140,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Green card/cash sticking out (back)
                      Positioned(
                        top: 10,
                        left: 30,
                        child: Container(
                          width: 70,
                          height: 35,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32), // Darker green
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      // Green card/cash sticking out (front)
                      Positioned(
                        top: 0,
                        left: 35,
                        child: Container(
                          width: 76,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFF81C784), // Light green
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      // Main blue wallet body
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 130,
                          height: 85,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1976D2), // Blue
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              // Wallet clasp/button on the right
                              Positioned(
                                right: 16,
                                top: 32,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1976D2),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              const Text(
                'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Bottom buttons for navigation
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Bắt đầu (Mở Dashboard)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddEditScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1976D2),
                        side: const BorderSide(color: Color(0xFF1976D2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Thêm GD'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final sampleTx = TransactionModel(
                          id: 1,
                          title: 'Ăn trưa',
                          amount: 100000,
                          date: '12/04/2025',
                          category: 'Ăn uống',
                          type: 'expense',
                          note: 'Ăn trưa',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditScreen(transaction: sampleTx),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1976D2),
                        side: const BorderSide(color: Color(0xFF1976D2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Sửa GD'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
