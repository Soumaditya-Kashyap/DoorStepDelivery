import 'package:project/helper/utils/generalImports.dart';

class ColorsRes {
  // Primary brand color - Bold and vibrant amber/orange from the logo
  static MaterialColor appColor = const MaterialColor(
    0xffFF9500, // Bold vibrant amber/orange - more dense and striking
    <int, Color>{
      50: Color(0xffFFF4E6),
      100: Color(0xffFFE4B3),
      200: Color(0xffFFD480),
      300: Color(0xffFFC44D),
      400: Color(0xffFFB81A),
      500: Color(0xffFF9500), // Main bold color
      600: Color(0xffE68500),
      700: Color(0xffCC7500),
      800: Color(0xffB36500),
      900: Color(0xff804700),
    },
  );

  // Brand color variations
  static Color appColorLight = const Color(0xffFFF4E6); // Very light amber
  static Color appColorLightHalfTransparent = const Color(0x66FF9500); // Higher opacity
  static Color appColorDark = const Color(0xffCC7500); // Darker bold amber

  // Gradient colors inspired by the logo
  static Color gradient1 = const Color(0xffFFB81A); // Bold light amber
  static Color gradient2 = const Color(0xffFF9500); // Main bold amber

  // Page background circles
  static Color defaultPageInnerCircle = const Color(0x1A2C2C2C);
  static Color defaultPageOuterCircle = const Color(0x0D2C2C2C);

  // Text colors
  static Color mainTextColor = const Color(0xde000000);

  // Light theme text colors
  static Color mainTextColorLight = const Color(0xff2C2C2C); // Dark charcoal from logo
  static Color mainTextColorDark = const Color(0xffF5F5DC); // Cream from logo

  static Color subTitleMainTextColor = const Color(0x94000000);

  // Subtitle colors
  static Color subTitleTextColorLight = const Color(0xff6B6B6B); // Medium gray
  static Color subTitleTextColorDark = const Color(0xffC4B897); // Warm beige

  static Color mainIconColor = const Color(0xffF5F5DC); // Cream

  // Background colors
  static Color bgColorLight = const Color(0xffFAF8F3); // Warm off-white
  static Color bgColorDark = const Color(0xff1C1C1C); // Rich dark from logo

  // Card colors
  static Color cardColorLight = const Color(0xffFFFEFB); // Pure warm white
  static Color cardColorDark = const Color(0xff2A2A2A); // Dark charcoal

  // Standard colors with brand twist
  static Color grey = const Color(0xff6B6B6B);
  static Color lightGrey = const Color(0xffB8B8B8);
  static Color appColorWhite = const Color(0xffFFFEFB); // Warm white
  static Color appColorBlack = const Color(0xff2C2C2C); // Logo black
  static Color appColorRed = const Color(0xffD2691E); // Warm red-orange
  static Color appColorGreen = const Color(0xff8B7355); // Earthy green

  // Box colors
  static Color greyBox = const Color(0x0A2C2C2C);
  static Color lightGreyBox = const Color(0x0AFAF8F3);

  // Shimmer colors (same for both themes initially)
  static Color shimmerBaseColor = const Color(0xffFFFEFB);
  static Color shimmerHighlightColor = const Color(0xffFFFEFB);
  static Color shimmerContentColor = const Color(0xffFFFEFB);

  // Dark theme shimmer colors
  static Color shimmerBaseColorDark = const Color(0x0D6B6B6B);
  static Color shimmerHighlightColorDark = const Color(0x05B8B8B8);
  static Color shimmerContentColorDark = const Color(0xff2C2C2C);

  // Light theme shimmer colors
  static Color shimmerBaseColorLight = const Color(0x0D2C2C2C);
  static Color shimmerHighlightColorLight = const Color(0x056B6B6B);
  static Color shimmerContentColorLight = const Color(0xffFFFEFB);

  // Rating colors
  static Color activeRatingColor = const Color(0xffFF9500); // Bold brand amber
  static Color deActiveRatingColor = const Color(0xffB8B8B8);

  // Status background colors with brand harmony
  static Color statusBgColorPendingPayment = const Color(0xffFFF4E6); // Bold light amber
  static Color statusBgColorReceived = const Color(0xffF0F8F0); // Light green
  static Color statusBgColorProcessed = const Color(0xffF5F3FF); // Light purple
  static Color statusBgColorShipped = const Color(0xffEBF8FF); // Light blue
  static Color statusBgColorOutForDelivery = const Color(0xffFFF4E6); // Bold warm light
  static Color statusBgColorDelivered = const Color(0xffF0F8F0); // Success green
  static Color statusBgColorCancelled = const Color(0xffFFF0F0); // Light red
  static Color statusBgColorReturned = const Color(0xffFFF4E6); // Bold amber tint

  static List<Color> statusBgColor = [
    statusBgColorPendingPayment,
    statusBgColorReceived,
    statusBgColorProcessed,
    statusBgColorShipped,
    statusBgColorOutForDelivery,
    statusBgColorDelivered,
    statusBgColorCancelled,
    statusBgColorReturned,
  ];

  // Status text colors
  static Color statusTextColorPendingPayment = const Color(0xffCC7500); // Bold dark amber
  static Color statusTextColorReceived = const Color(0xff2E7D32); // Forest green
  static Color statusTextColorProcessed = const Color(0xff6A1B9A); // Purple
  static Color statusTextColorShipped = const Color(0xff1565C0); // Blue
  static Color statusTextColorOutForDelivery = const Color(0xff2C2C2C); // Charcoal
  static Color statusTextColorDelivered = const Color(0xff388E3C); // Success green
  static Color statusTextColorCancelled = const Color(0xffD32F2F); // Red
  static Color statusTextColorReturned = const Color(0xffFF9500); // Bold brand amber

  static List<Color> statusTextColor = [
    statusTextColorPendingPayment,
    statusTextColorReceived,
    statusTextColorProcessed,
    statusTextColorShipped,
    statusTextColorOutForDelivery,
    statusTextColorDelivered,
    statusTextColorCancelled,
    statusTextColorReturned,
  ];

  static ThemeData lightTheme = ThemeData(
    primaryColor: appColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgColorLight,
    cardColor: cardColorLight,
    iconTheme: IconThemeData(
      color: grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: appColor,
      foregroundColor: appColorWhite,
      iconTheme: IconThemeData(
        color: appColorWhite,
      ),
      titleTextStyle: TextStyle(
        color: appColorWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: ColorsRes.appColor).copyWith(
      surface: bgColorLight,
      brightness: Brightness.light,
      primary: appColor,
      secondary: Color(0xffCC7500),
    ),
    cardTheme: CardTheme(
      color: cardColorLight,
      surfaceTintColor: cardColorLight,
      shadowColor: Color(0x1A2C2C2C),
      elevation: 2,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: appColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColorDark,
    cardColor: cardColorDark,
    iconTheme: IconThemeData(
      color: Color(0xffC4B897),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xff2A2A2A),
      foregroundColor: Color(0xffF5F5DC),
      iconTheme: IconThemeData(
        color: Color(0xffF5F5DC),
      ),
      titleTextStyle: TextStyle(
        color: Color(0xffF5F5DC),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: ColorsRes.appColor).copyWith(
      surface: bgColorDark,
      brightness: Brightness.dark,
      primary: appColor,
      secondary: Color(0xffFFB81A),
    ),
    cardTheme: CardTheme(
      color: cardColorDark,
      surfaceTintColor: cardColorDark,
      shadowColor: Color(0x1A000000),
      elevation: 4,
    ),
  );

  static ThemeData setAppTheme() {
    String theme = Constant.session.getData(SessionManager.appThemeName);
    bool isDarkTheme = Constant.session.getBoolData(SessionManager.isDarkTheme);

    bool isDark = false;
    if (theme == Constant.themeList[2]) {
      isDark = true;
    } else if (theme == Constant.themeList[1]) {
      isDark = false;
    } else if (theme == "" || theme == Constant.themeList[0]) {
      var brightness = PlatformDispatcher.instance.platformBrightness;
      isDark = brightness == Brightness.dark;

      if (theme == "") {
        Constant.session
            .setData(SessionManager.appThemeName, Constant.themeList[0], false);
      }
    }

    if (isDark) {
      if (!isDarkTheme) {
        Constant.session.setBoolData(SessionManager.isDarkTheme, true, false);
      }
      mainTextColor = mainTextColorDark;
      subTitleMainTextColor = subTitleTextColorDark;

      shimmerBaseColor = shimmerBaseColorDark;
      shimmerHighlightColor = shimmerHighlightColorDark;
      shimmerContentColor = shimmerContentColorDark;
      return darkTheme;
    } else {
      if (isDarkTheme) {
        Constant.session.setBoolData(SessionManager.isDarkTheme, false, false);
      }
      mainTextColor = mainTextColorLight;
      subTitleMainTextColor = subTitleTextColorLight;

      shimmerBaseColor = shimmerBaseColorLight;
      shimmerHighlightColor = shimmerHighlightColorLight;
      shimmerContentColor = shimmerContentColorLight;
      return lightTheme;
    }
  }
}

String colorToHex(Color color) {
  final red = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
  final green = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
  final blue = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');
  final alpha = (color.a * 255).toInt().toRadixString(16).padLeft(2, '0');

  return '#$alpha$red$green$blue';
}