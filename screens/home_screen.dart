import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../utils/theme_manager.dart';
import '../widgets/bento_card.dart';
import 'emi_calculator_screen.dart';
import 'compare_loans_screen.dart';
import 'tax_screen.dart';
import 'sip_calculator_screen.dart';
import 'fd_calculator_screen.dart';
import 'rd_calculator_screen.dart';
import 'ppf_calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _bannerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Header animation
    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Banner slide animation
    _bannerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    // Staggered card animations
    _cardAnimations = List.generate(7, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.2 + (index * 0.1),
            0.6 + (index * 0.1),
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              // Animated Header
              AnimatedBuilder(
                animation: _headerAnimation,
                builder: (context, child) {
              return Opacity(
                opacity: _headerAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - _headerAnimation.value)),
                  child: _buildHeader(isDark),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Animated Stats Banner
          AnimatedBuilder(
            animation: _bannerSlideAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: _bannerSlideAnimation,
                child: _buildStatsBanner(isDark),
              );
            },
          ),
          const SizedBox(height: 32),
          
          // Section Title with animation
          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _headerAnimation.value,
                child: _buildSectionHeader(isDark),
              );
            },
          ),
          const SizedBox(height: 20),
          
          // Animated Bento Grid
          _buildAnimatedBentoGrid(context, isDark),
        ],
      ),
    );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTheme.getBodyLarge(isDark: isDark).copyWith(
            color: AppTheme.getTextSecondary(isDark),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('Welcome to ', style: AppTheme.getHeadingLarge(isDark: isDark).copyWith(
              color: isDark ? AppTheme.getTextPrimary(isDark) : Colors.black,
            )),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDark],
              ).createShader(bounds),
              child: Text(
                'FinCalc!',
                style: AppTheme.getHeadingLarge(isDark: isDark).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'What would you like to calculate today?',
          style: AppTheme.getBodyMedium(isDark: isDark).copyWith(
            color: isDark ? AppTheme.getTextSecondary(isDark) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryStart.withValues(alpha: 0.15),
            AppTheme.primaryEnd.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryStart.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryStart.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryStart, AppTheme.primaryEnd],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Tools at Your Fingertips',
                      style: AppTheme.headingSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppTheme.textPrimary : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Calculate, compare, and plan your finances',
                      style: AppTheme.bodySmall.copyWith(
                        color: isDark ? AppTheme.textSecondary : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.calculate_rounded, '7', 'Calculators', isDark),
              _buildStatDivider(),
              _buildStatItem(Icons.speed_rounded, 'Fast', 'Results', isDark),
              _buildStatDivider(),
              _buildStatItem(Icons.security_rounded, '100%', 'Secure', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryStart.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryStart,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.textPrimary : Colors.black,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: isDark ? AppTheme.textSecondary : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppTheme.cardBorder,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Access',
              style: AppTheme.headingMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.textPrimary : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose a calculator to get started',
              style: AppTheme.bodySmall.copyWith(
                color: isDark ? AppTheme.textMuted : Colors.black54,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentTeal.withValues(alpha: 0.2),
                AppTheme.accentTeal.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.accentTeal.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.apps_rounded,
                size: 16,
                color: AppTheme.accentTeal,
              ),
              const SizedBox(width: 6),
              Text(
                '7 Tools',
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.accentTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedBentoGrid(BuildContext context, bool isDark) {
    final cards = [
      // EMI Calculator (Large)
      BentoCard(
        title: 'EMI Calculator',
        subtitle: 'Calculate your monthly loan payments instantly',
        icon: Icons.percent_rounded,
        gradientColors: AppTheme.primaryGradient.colors,
        size: BentoSize.large,
        onTap: () => _navigateTo(context, const EMICalculatorScreen()),
        isDark: isDark,
      ),
      // Compare Loans
      BentoCard(
        title: 'Compare\nLoans',
        subtitle: 'Side by side comparison',
        icon: Icons.compare_arrows_rounded,
        gradientColors: AppTheme.primaryGradient.colors,
        size: BentoSize.medium,
        onTap: () => _navigateTo(context, const CompareLoansScreen()),
        isDark: isDark,
      ),
      // GST Calculator
      BentoCard(
        title: 'GST',
        subtitle: 'Tax calculator',
        icon: Icons.receipt_long_rounded,
        gradientColors: AppTheme.primaryGradient.colors,
        size: BentoSize.small,
        onTap: () => _navigateTo(context, const TaxScreen()),
        isDark: isDark,
      ),
      // SIP Calculator
      BentoCard(
        title: 'SIP',
        subtitle: 'Investment planner',
        icon: Icons.auto_graph_rounded,
        gradientColors: AppTheme.successGradient.colors,
        size: BentoSize.small,
        onTap: () => _navigateTo(context, const SIPCalculatorScreen()),
        isDark: isDark,
      ),
      // FD Calculator
      BentoCard(
        title: 'FD',
        subtitle: 'Fixed deposit',
        icon: Icons.savings_rounded,
        gradientColors: AppTheme.successGradient.colors,
        size: BentoSize.small,
        onTap: () => _navigateTo(context, const FDCalculatorScreen()),
        isDark: isDark,
      ),
      // RD Calculator
      BentoCard(
        title: 'RD Calculator',
        subtitle: 'Recurring deposit returns',
        icon: Icons.account_balance_wallet_rounded,
        gradientColors: AppTheme.successGradient.colors,
        size: BentoSize.medium,
        onTap: () => _navigateTo(context, const RDCalculatorScreen()),
        isDark: isDark,
      ),
      // PPF Calculator
      BentoCard(
        title: 'PPF',
        subtitle: 'Provident fund',
        icon: Icons.assured_workload_rounded,
        gradientColors: AppTheme.successGradient.colors,
        size: BentoSize.small,
        onTap: () => _navigateTo(context, const PPFCalculatorScreen()),
        isDark: isDark,
      ),
    ];

    return Column(
      children: [
        // Row 1: Large EMI + Compare Loans
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 0.85,
                child: AnimatedBuilder(
                  animation: _cardAnimations[0],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _cardAnimations[0].value,
                      child: Opacity(
                        opacity: _cardAnimations[0].value,
                        child: cards[0],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 0.85,
                child: AnimatedBuilder(
                  animation: _cardAnimations[1],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _cardAnimations[1].value,
                      child: Opacity(
                        opacity: _cardAnimations[1].value,
                        child: cards[1],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 2: GST + SIP + FD
        Row(
          children: [
            ...List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < 2 ? 12 : 0,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: AnimatedBuilder(
                      animation: _cardAnimations[index + 2],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _cardAnimations[index + 2].value,
                          child: Opacity(
                            opacity: _cardAnimations[index + 2].value,
                            child: cards[index + 2],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 3: RD (wide) + PPF
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1.8,
                child: AnimatedBuilder(
                  animation: _cardAnimations[5],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _cardAnimations[5].value,
                      child: Opacity(
                        opacity: _cardAnimations[5].value,
                        child: cards[5],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.9,
                child: AnimatedBuilder(
                  animation: _cardAnimations[6],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _cardAnimations[6].value,
                      child: Opacity(
                        opacity: _cardAnimations[6].value,
                        child: cards[6],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
