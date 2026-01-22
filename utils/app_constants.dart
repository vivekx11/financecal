class AppConstants {
  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 10.0;
  static const double radiusL = 14.0;
  static const double radiusXL = 20.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Calculator Limits
  static const double maxLoanAmount = 100000000; // 10 Cr
  static const double maxInterestRate = 50.0;
  static const int maxTenureYears = 40;
  static const int maxTenureMonths = 480;
  static const double maxSIPAmount = 10000000; // 1 Cr
  static const double maxPPFYearlyAmount = 150000; // 1.5 Lakh (PPF limit)
  static const double currentPPFRate = 7.1; // Current PPF rate

  // GST Rates
  static const List<double> gstRates = [5.0, 12.0, 18.0, 28.0];

  // Compounding Frequencies
  static const Map<String, int> compoundingFrequency = {
    'Yearly': 1,
    'Half-Yearly': 2,
    'Quarterly': 4,
    'Monthly': 12,
  };
}
