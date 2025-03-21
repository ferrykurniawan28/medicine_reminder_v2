part of 'helpers.dart';

TextStyle titleTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: bold,
);

TextStyle subtitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: medium,
);

TextStyle bodyTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: normal,
);

TextStyle captionTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: light,
);

FontWeight bold = FontWeight.bold;
FontWeight semiBold = FontWeight.w600;
FontWeight medium = FontWeight.w500;
FontWeight normal = FontWeight.normal;
FontWeight light = FontWeight.w300;

BoxShadow defaultShadow = BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 20,
  offset: const Offset(0, 3),
);
