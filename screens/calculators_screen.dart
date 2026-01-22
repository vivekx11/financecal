import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../utils/theme_manager.dart';
import 'emi_calculator_screen.dart';
import 'compare_loans_screen.dart';
import 'tax_screen.dart';
import 'sip_calculator_screen.dart';
import 'fd_calculator_screen.dart';
import 'rd_calculator_screen.dart';
import 'ppf_calculator_screen.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        final isDark = themeManager.isDarkMode;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.paddingM,
            AppConstants.paddingL,
            AppConstants.paddingM,
            120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All Calculators', style: AppTheme.getHeadingLarge(isDark: isDark).copyWith(
                color: isDark ? AppTheme.getTextPrimary(isDark) : Colors.black,
              )),
              const SizedBox(height: 8),
              Text(
                'Choose a calculator to get started',
                style: AppTheme.getBodyMedium(isDark: isDark),
              ),
              const SizedBox(height: 24),
              
              // Loans Section
              _buildSectionHeader('Loans & EMI', Icons.account_balance_rounded, isDark),
              const SizedBox(height: 12),
          _buildCalculatorTile(
            context,
            'EMI Calculator',
            'Calculate monthly EMI for loans',
            Icons.percent_rounded,
            AppTheme.primaryGradient.colors,
            const EMICalculatorScreen(),
            isDark,
          ),
          _buildCalculatorTile(
            context,
            'Compare Loans',
            'Compare different loan offers side by side',
            Icons.compare_arrows_rounded,
            AppTheme.primaryGradient.colors,
            const CompareLoansScreen(),
            isDark,
          ),
          
          const SizedBox(height: 24),
          
          // Investments Section
          _buildSectionHeader('Investments', Icons.trending_up_rounded, isDark),
          const SizedBox(height: 12),
          _buildCalculatorTile(
            context,
            'SIP Calculator',
            'Plan your systematic investment portfolio',
            Icons.auto_graph_rounded,
            AppTheme.successGradient.colors,
            const SIPCalculatorScreen(),
            isDark,
          ),
          _buildCalculatorTile(
            context,
            'FD Calculator',
            'Calculate fixed deposit maturity amount',
            Icons.savings_rounded,
            AppTheme.successGradient.colors,
            const FDCalculatorScreen(),
            isDark,
          ),
          _buildCalculatorTile(
            context,
            'RD Calculator',
            'Calculate recurring deposit returns',
            Icons.account_balance_wallet_rounded,
            AppTheme.successGradient.colors,
            const RDCalculatorScreen(),
            isDark,
          ),
          _buildCalculatorTile(
            context,
            'PPF Calculator',
            'Plan your Public Provident Fund investments',
            Icons.assured_workload_rounded,
            AppTheme.successGradient.colors,
            const PPFCalculatorScreen(),
            isDark,
          ),
          
          const SizedBox(height: 24),
          
          // Tax Section
          _buildSectionHeader('Tax & GST', Icons.receipt_long_rounded, isDark),
          const SizedBox(height: 12),
          _buildCalculatorTile(
            context,
            'GST Calculator',
            'Calculate GST inclusive/exclusive amounts',
            Icons.receipt_rounded,
            AppTheme.primaryGradient.colors,
            const TaxScreen(),
            isDark,
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryStart.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryStart,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTheme.getHeadingSmall(isDark: isDark).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    List<Color> gradientColors,
    Widget screen,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.getCardDecoration(isDark: isDark),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTheme.getBodyLarge(isDark: isDark).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: AppTheme.getBodySmall(isDark: isDark),
                          ),
                        ],
                      ),
                    ),
                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.getTextMuted(isDark),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
