part of 'helpers.dart';

const Color kPrimaryColor = Color(0xFF27A8B5);
const Color kSecondaryColor = Color(0xFF1B93A5);
const Color kAccentColor = Color(0xFF095A6F);

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
  // ignore: deprecated_member_use
  color: Colors.black.withOpacity(0.1),
  blurRadius: 5,
  spreadRadius: 1,
  offset: const Offset(1, 3),
);

AppBar defaultAppBar(String title, {Widget? leading, List<Widget>? actions}) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(title),
    centerTitle: true,
    elevation: 0,
    leading: leading,
    actions: actions,
  );
}
