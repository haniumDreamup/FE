library toss_theme;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 토스 스타일 테마 설정
/// 미니멀하고 깔끔한 디자인 with BIF 접근성
class TossTheme {
  // Primary color for easier access
  static const Color primaryColor = Color(0xFF0064FF);

  // 토스 컬러 시스템
  static const Color tossBlue = Color(0xFF0064FF);
  static const Color tossBlack = Color(0xFF1A1A1A);
  static const Color tossGray900 = Color(0xFF191F28);
  static const Color tossGray800 = Color(0xFF333D4B);
  static const Color tossGray700 = Color(0xFF4E5968);
  static const Color tossGray600 = Color(0xFF6B7684);
  static const Color tossGray500 = Color(0xFF8B95A1);
  static const Color tossGray400 = Color(0xFFB0B8C1);
  static const Color tossGray300 = Color(0xFFD1D6DB);
  static const Color tossGray200 = Color(0xFFE5E8EB);
  static const Color tossGray100 = Color(0xFFF2F4F6);
  static const Color tossGray50 = Color(0xFFF9FAFB);
  static const Color tossWhite = Color(0xFFFFFFFF);

  // 시맨틱 컬러
  static const Color tossRed = Color(0xFFF04452);
  static const Color tossGreen = Color(0xFF00C896);
  static const Color tossYellow = Color(0xFFFFB800);
  static const Color tossPurple = Color(0xFF8B5CF6);
  static const Color tossOrange = Color(0xFFFF7300);

  // ThemeConfig 호환을 위한 별칭 (마이그레이션용)
  static const Color secondaryColor = tossOrange;
  static const Color successColor = tossGreen;
  static const Color warningColor = tossYellow;
  static const Color errorColor = tossRed;
  static const Color infoColor = Color(0xFF36B0C9);
  static const Color backgroundColor = tossGray50;
  static const Color textColor = tossGray900;
  static const Color lightTextColor = tossGray600;
  static const Color disabledColor = tossGray300;
  static const Color borderColor = tossGray200;
  
  // 토스 스타일 그림자
  static List<BoxShadow> tossShadowSmall = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> tossShadowMedium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> tossShadowLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];
  
  // 토스 스타일 테마
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard', // 토스 폰트 (설치 필요)
    
    // 컬러 스킴
    colorScheme: const ColorScheme.light(
      primary: tossBlue,
      onPrimary: tossWhite,
      secondary: tossGray700,
      onSecondary: tossWhite,
      surface: tossWhite,
      onSurface: tossGray900,
      error: tossRed,
      onError: tossWhite,
    ),
    
    // 앱바 테마
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: tossWhite,
      foregroundColor: tossGray900,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        color: tossGray900,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(
        color: tossGray900,
        size: 24,
      ),
    ),
    
    // 카드 테마
    cardTheme: CardThemeData(
      elevation: 0,
      color: tossWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),
    
    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: tossBlue,
        foregroundColor: tossWhite,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: tossBlue,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: tossGray700,
        side: const BorderSide(color: tossGray200, width: 1.5),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    
    // 텍스트 테마
    textTheme: const TextTheme(
      // Display
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: tossGray900,
        height: 1.3,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: tossGray900,
        height: 1.3,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: tossGray900,
        height: 1.3,
      ),
      
      // Headline
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: tossGray900,
        height: 1.4,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: tossGray900,
        height: 1.4,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: tossGray900,
        height: 1.4,
      ),
      
      // Title
      titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: tossGray900,
        height: 1.5,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: tossGray900,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: tossGray900,
        height: 1.5,
      ),
      
      // Body
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.2,
        color: tossGray700,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        color: tossGray700,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: tossGray600,
        height: 1.6,
      ),
      
      // Label
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: tossGray600,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: tossGray600,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: tossGray500,
        height: 1.4,
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tossGray50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: tossBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: tossRed, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: tossRed, width: 2),
      ),
      labelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: tossGray600,
      ),
      hintStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: tossGray400,
      ),
      errorStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: tossRed,
      ),
    ),
    
    // 바텀시트 테마
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: tossWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      dragHandleColor: tossGray300,
    ),
    
    // 스낵바 테마
    snackBarTheme: SnackBarThemeData(
      backgroundColor: tossGray800,
      contentTextStyle: const TextStyle(
        color: tossWhite,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
    
    // Divider 테마
    dividerTheme: const DividerThemeData(
      color: tossGray100,
      thickness: 1,
      space: 1,
    ),
    
    // Scaffold Background
    scaffoldBackgroundColor: tossGray50,
  );

  // 토스 스타일 다크 테마
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard',
    brightness: Brightness.dark,

    // 다크모드 컬러 스킴
    colorScheme: const ColorScheme.dark(
      primary: tossBlue,
      onPrimary: tossWhite,
      secondary: tossGray400,
      onSecondary: tossBlack,
      surface: tossGray900,
      onSurface: tossGray100,
      error: tossRed,
      onError: tossWhite,
    ),

    // 앱바 테마
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: tossGray900,
      foregroundColor: tossGray100,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        color: tossGray100,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(
        color: tossGray100,
        size: 24,
      ),
    ),

    // 카드 테마
    cardTheme: CardThemeData(
      elevation: 0,
      color: tossGray800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),

    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: tossBlue,
        foregroundColor: tossWhite,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: tossBlue,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: tossGray300,
        side: const BorderSide(color: tossGray700, width: 1.5),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tossGray800,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: tossBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: tossRed, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: tossRed, width: 2),
      ),
      labelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: tossGray400,
      ),
      hintStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: tossGray600,
      ),
      errorStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: tossRed,
      ),
    ),

    // 바텀시트 테마
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: tossGray900,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      dragHandleColor: tossGray600,
    ),

    // 스낵바 테마
    snackBarTheme: SnackBarThemeData(
      backgroundColor: tossGray700,
      contentTextStyle: const TextStyle(
        color: tossWhite,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),

    // Divider 테마
    dividerTheme: const DividerThemeData(
      color: tossGray800,
      thickness: 1,
      space: 1,
    ),

    // Scaffold Background
    scaffoldBackgroundColor: tossBlack,
  );

  // 토스 스타일 애니메이션 커브
  static const Curve tossAnimationCurve = Curves.easeInOutCubic;
  static const Duration tossAnimationDuration = Duration(milliseconds: 300);
  static const Duration tossAnimationDurationFast = Duration(milliseconds: 200);
  static const Duration tossAnimationDurationSlow = Duration(milliseconds: 500);
}

/// 토스 컬러 시스템을 쉽게 사용하기 위한 유틸리티 클래스
class TossColors {
  static const Color blue50 = Color(0xFFF0F8FF);
  static const Color blue100 = Color(0xFFE6F3FF);
  static const Color blue200 = Color(0xFFB3DEFF);
  static const Color blue300 = Color(0xFF80C9FF);
  static const Color blue400 = Color(0xFF4DB4FF);
  static const Color blue500 = Color(0xFF0064FF);
  static const Color blue600 = Color(0xFF0050CC);
  static const Color blue700 = Color(0xFF003C99);
  static const Color blue800 = Color(0xFF002866);
  static const Color blue900 = Color(0xFF001433);

  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF2F4F6);
  static const Color grey200 = Color(0xFFE5E8EB);
  static const Color grey300 = Color(0xFFD1D6DB);
  static const Color grey400 = Color(0xFFB0B8C1);
  static const Color grey500 = Color(0xFF8B95A1);
  static const Color grey600 = Color(0xFF6B7684);
  static const Color grey700 = Color(0xFF4E5968);
  static const Color grey800 = Color(0xFF333D4B);
  static const Color grey900 = Color(0xFF191F28);

  static const Color red50 = Color(0xFFFFF5F5);
  static const Color red100 = Color(0xFFFFE5E7);
  static const Color red200 = Color(0xFFFFBFC2);
  static const Color red300 = Color(0xFFFF999E);
  static const Color red400 = Color(0xFFFF737A);
  static const Color red500 = Color(0xFFF04452);
  static const Color red600 = Color(0xFFD93341);
  static const Color red700 = Color(0xFFB32330);
  static const Color red800 = Color(0xFF8C1220);
  static const Color red900 = Color(0xFF66010F);

  static const Color green50 = Color(0xFFF0FDF9);
  static const Color green100 = Color(0xFFE6FBF3);
  static const Color green200 = Color(0xFFBFF4E1);
  static const Color green300 = Color(0xFF99EDCF);
  static const Color green400 = Color(0xFF73E6BD);
  static const Color green500 = Color(0xFF00C896);
  static const Color green600 = Color(0xFF00A078);
  static const Color green700 = Color(0xFF00785A);
  static const Color green800 = Color(0xFF00503C);
  static const Color green900 = Color(0xFF00281E);

  static const Color yellow50 = Color(0xFFFFFDF0);
  static const Color yellow100 = Color(0xFFFFF9E0);
  static const Color yellow200 = Color(0xFFFFF2B3);
  static const Color yellow300 = Color(0xFFFFEB80);
  static const Color yellow400 = Color(0xFFFFE44D);
  static const Color yellow500 = Color(0xFFFFB800);
  static const Color yellow600 = Color(0xFFCC9300);
  static const Color yellow700 = Color(0xFF996E00);
  static const Color yellow800 = Color(0xFF664A00);
  static const Color yellow900 = Color(0xFF332500);

  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange100 = Color(0xFFFFE4CC);
  static const Color orange200 = Color(0xFFFFCC99);
  static const Color orange300 = Color(0xFFFFB366);
  static const Color orange400 = Color(0xFFFF9A33);
  static const Color orange500 = Color(0xFFFF7300);
  static const Color orange600 = Color(0xFFCC5C00);
  static const Color orange700 = Color(0xFF994500);
  static const Color orange800 = Color(0xFF662E00);
  static const Color orange900 = Color(0xFF331700);

  static const Color purple50 = Color(0xFFF8F5FF);
  static const Color purple100 = Color(0xFFEDE5FF);
  static const Color purple200 = Color(0xFFD9CCFF);
  static const Color purple300 = Color(0xFFC6B2FF);
  static const Color purple400 = Color(0xFFB299FF);
  static const Color purple500 = Color(0xFF8B5CF6);
  static const Color purple600 = Color(0xFF7C3AED);
  static const Color purple700 = Color(0xFF6D28D9);
  static const Color purple800 = Color(0xFF5B21B6);
  static const Color purple900 = Color(0xFF4C1D95);
}

/// 토스 텍스트 스타일 시스템을 쉽게 사용하기 위한 유틸리티 클래스
class TossTextStyle {
  // Display styles
  static const TextStyle display1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.3,
  );

  // Header styles
  static const TextStyle header1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.3,
  );

  static const TextStyle header2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.4,
  );

  static const TextStyle header3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.4,
  );

  // Body styles
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.6,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.6,
  );

  static const TextStyle body3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.6,
  );

  // Caption styles
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle caption2 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // Button styles
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );
}