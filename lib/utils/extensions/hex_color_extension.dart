import 'dart:ui';

extension HexColorExtension on String {
  /// Converts a hex color code string (e.g., "#RRGGBB") to a [Color].
  Color toColor() {
    final hexCode = replaceFirst('#', '');
    return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
  }
}
