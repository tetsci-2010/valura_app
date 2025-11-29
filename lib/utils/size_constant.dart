import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valura/utils/my_media_query.dart';

/// Standard responsive size constants based on Material Design 3 spacing
/// and Flutter community conventions.
///
/// Call `ScreenUtilInit` in your app’s root widget (see usage below).
class SizeConstants {
  double mobileView = 660;
  // Base Spacing (Material 3 standard spacing steps)
  double get spacing2 => 2.w;
  double get spacing4 => 4.w;
  double get spacing8 => 8.w;
  double get spacing12 => 12.w;
  double get spacing16 => 16.w;
  double get spacing20 => 20.w;
  double get spacing24 => 24.w;
  double get spacing32 => 32.w;
  double get spacing40 => 40.w;
  double get spacing48 => 48.w;
  double get spacing56 => 56.w;
  double get spacing64 => 64.w;

  // Font Sizes (typography scale)
  double get fontXS => 10.sp;
  double get fontS => 12.sp;
  double get fontM => 14.sp;
  double get fontL => 16.sp;
  double get fontXL => 20.sp;
  double get fontXXL => 24.sp;
  double get fontXXXL => 32.sp;

  // Icon Sizes
  double get iconS => 16.w;
  double get iconM => 24.w;
  double get iconL => 32.w;
  double get iconXL => 48.w;

  // Border Radius (M3 rounding standard)
  double get radiusSmall => 4.r;
  double get radiusMedium => 8.r;
  double get radiusLarge => 16.r;
  double get radiusXLarge => 28.r;

  // Common widget heights
  double get buttonHeight => 48.h;
  double get inputHeight => 56.h;

  // Screen-aware helpers
  double get screenWidth => 1.sw;
  double get screenHeight => 1.sh;

  // Lottie animation
  double get imageLarge => 250.w;
  double get imageMedium => 180.w;
  double get imageSmall => 100.w;

  // Buttons & icons
  double get iconLarge => 48.w;
  double get iconMedium => 36.w;
  double get iconSmall => 24.w;

  // ✅ Compact card — for small tiles (e.g., notification or tag cards)
  double cardCompactWidth = 120.0;
  double cardCompactHeight = 100.0;

  // ✅ Standard card — for most use cases (e.g., info or content cards)
  double cardStandardWidth = 160.0;
  double cardStandardHeight = 140.0;

  // ✅ Large card — for highlighted content or banners
  double cardLargeWidth = 200.0;
  double cardLargeHeight = 180.0;

  // Used for profile pictures, initials, or icons.
  double avatarXS = 20.0; // Very small, e.g., chat bubbles
  double avatarSmall = 32.0; // Small lists or icons
  double avatarMedium = 48.0; // Default user avatar
  double avatarLarge = 64.0; // Profile pages or tiles
  double avatarXLarge = 80.0; // Highlighted or hero avatars

  // Responsive option for dynamic avatar sizing
  double avatarResponsive(BuildContext context, double scale) => getMediaQueryWidth(context, scale) * 0.25;

  // font sizes
  double get fontDisplayLarge => 40.sp; // app name / splash
  double get fontDisplayMedium => 36.sp; // big hero text
  double get fontHeadlineLarge => 32.sp; // page title
  double get fontHeadlineMedium => 28.sp; // section title
  double get fontTitleLarge => 24.sp; // card / dialog title
  double get fontTitleMedium => 22.sp; // medium heading
  double get fontBodyLarge => 18.sp; // regular readable body
  double get fontBodyMedium => 16.sp; // secondary text
  double get fontLabelLarge => 12.sp; // button text
  double get fontLabelSmall => 8.sp; // caption / helper text
}

SizeConstants sizeConstants = SizeConstants();
