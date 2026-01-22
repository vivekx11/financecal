import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../utils/theme_manager.dart';
import '../services/history_service.dart';
import '../models/calculation_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<CalculationModel> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await HistoryService.instance.getHistory();
    if (mounted) {
      setState(() {
        _history = history;
        _isLoading = false;
      });
    }
  }

  Future<void> _clearHistory() async {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    final isDark = themeManager.isDarkMode;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.getSurface(isDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: Text(
          'Clear History',
          style: AppTheme.getHeadingSmall(isDark: isDark),
        ),
        content: Text(
          'Are you sure you want to clear all history? This action cannot be undone.',
          style: AppTheme.getBodyMedium(isDark: isDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTheme.getBodyMedium(
                isDark: isDark,
              ).copyWith(color: AppTheme.getTextSecondary(isDark)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Clear',
              style: AppTheme.getBodyMedium(
                isDark: isDark,
              ).copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await HistoryService.instance.clearHistory();
      await _loadHistory();
    }
  }

  Future<void> _deleteItem(String id) async {
    await HistoryService.instance.deleteCalculation(id);
    await _loadHistory();
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Today, ${DateFormat.jm().format(dateTime)}';
    } else if (date == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(dateTime)}';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        final isDark = themeManager.isDarkMode;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: AppTheme.getBackground(isDark),
            body: SafeArea(
              top: true,
              bottom: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppConstants.paddingM,
                  AppConstants
                      .paddingM, // ← this makes title nicely below status bar
                  AppConstants.paddingM,
                  140,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'History',
                              style: AppTheme.getHeadingLarge(isDark: isDark)
                                  .copyWith(
                                    color: isDark
                                        ? AppTheme.getTextPrimary(isDark)
                                        : Colors.black,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your recent calculations',
                              style: AppTheme.getBodyMedium(isDark: isDark),
                            ),
                          ],
                        ),
                        if (_history.isNotEmpty)
                          GestureDetector(
                            onTap: _clearHistory,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Clear',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_history.isEmpty)
                      _buildEmptyState(isDark)
                    else
                      _buildHistoryGrid(isDark),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.getSurface(isDark),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppTheme.cardBorder
                      : AppTheme.cardBorderLight,
                ),
              ),
              child: Icon(
                Icons.history_rounded,
                size: 64,
                color: AppTheme.getTextMuted(isDark),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No calculations yet',
              style: AppTheme.getHeadingSmall(
                isDark: isDark,
              ).copyWith(color: AppTheme.getTextSecondary(isDark)),
            ),
            const SizedBox(height: 8),
            Text(
              'Your calculation history will appear here',
              style: AppTheme.getBodyMedium(
                isDark: isDark,
              ).copyWith(color: AppTheme.getTextMuted(isDark)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calculate_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Start Calculating',
                    style: AppTheme.getBodyLarge(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryGrid(bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final calculation = _history[index];
        return _buildHistoryCard(calculation, isDark);
      },
    );
  }

  Widget _buildHistoryCard(CalculationModel calculation, bool isDark) {
    final cardColor = Color(calculation.colorValue);

    return GestureDetector(
      onTap: () => _showDetailBottomSheet(calculation, isDark),
      onLongPress: () => _showDeleteDialog(calculation, isDark),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.getSurface(isDark),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(
            color: isDark ? AppTheme.cardBorder : AppTheme.cardBorderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cardColor, cardColor.withOpacity(0.5)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.radiusL),
                    topRight: Radius.circular(AppConstants.radiusL),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cardColor.withOpacity(0.2),
                              cardColor.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          IconData(
                            calculation.iconCode,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: cardColor,
                          size: 24,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          calculation.type,
                          style: AppTheme.getBodySmall(isDark: isDark).copyWith(
                            color: cardColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    calculation.title,
                    style: AppTheme.getBodyMedium(
                      isDark: isDark,
                    ).copyWith(color: AppTheme.getTextSecondary(isDark)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    calculation.result,
                    style: AppTheme.getHeadingSmall(isDark: isDark).copyWith(
                      fontSize: 18,
                      color: AppTheme.getTextPrimary(isDark),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppTheme.getTextMuted(isDark),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDate(calculation.timestamp),
                          style: AppTheme.getBodySmall(isDark: isDark).copyWith(
                            color: AppTheme.getTextMuted(isDark),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailBottomSheet(CalculationModel calculation, bool isDark) {
    final cardColor = Color(calculation.colorValue);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.getSurface(isDark),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.cardBorder
                      : AppTheme.cardBorderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cardColor.withOpacity(0.2),
                        cardColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    IconData(calculation.iconCode, fontFamily: 'MaterialIcons'),
                    color: cardColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        calculation.title,
                        style: AppTheme.getHeadingSmall(isDark: isDark),
                      ),
                      Text(
                        _formatDate(calculation.timestamp),
                        style: AppTheme.getBodySmall(
                          isDark: isDark,
                        ).copyWith(color: AppTheme.getTextMuted(isDark)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    calculation.type,
                    style: AppTheme.getBodyMedium(
                      isDark: isDark,
                    ).copyWith(color: cardColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cardColor.withOpacity(0.1),
                    cardColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Result: ',
                    style: AppTheme.getBodyLarge(
                      isDark: isDark,
                    ).copyWith(color: AppTheme.getTextSecondary(isDark)),
                  ),
                  Text(
                    calculation.result,
                    style: AppTheme.getHeadingMedium(
                      isDark: isDark,
                    ).copyWith(color: cardColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Details',
              style: AppTheme.getBodyLarge(
                isDark: isDark,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...calculation.details.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: AppTheme.getBodyMedium(
                        isDark: isDark,
                      ).copyWith(color: AppTheme.getTextSecondary(isDark)),
                    ),
                    Text(
                      entry.value,
                      style: AppTheme.getBodyMedium(
                        isDark: isDark,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteItem(calculation.id);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.withOpacity(0.3)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete_outline),
                    const SizedBox(width: 8),
                    Text(
                      'Delete from History',
                      style: AppTheme.getBodyMedium(
                        isDark: isDark,
                      ).copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(CalculationModel calculation, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.getSurface(isDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: Text(
          'Delete Calculation',
          style: AppTheme.getHeadingSmall(isDark: isDark),
        ),
        content: Text(
          'Are you sure you want to delete this ${calculation.type} calculation?',
          style: AppTheme.getBodyMedium(isDark: isDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.getBodyMedium(
                isDark: isDark,
              ).copyWith(color: AppTheme.getTextSecondary(isDark)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem(calculation.id);
            },
            child: Text(
              'Delete',
              style: AppTheme.getBodyMedium(
                isDark: isDark,
              ).copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
