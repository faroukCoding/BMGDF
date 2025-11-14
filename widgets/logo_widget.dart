import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;
  final LogoType type;

  const LogoWidget({
    Key? key,
    this.size = 50,
    this.showText = true,
    this.color,
    this.type = LogoType.full,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LogoType.iconOnly:
        return _buildIconOnly();
      case LogoType.textOnly:
        return _buildTextOnly();
      case LogoType.full:
      default:
        return _buildFullLogo();
    }
  }

  Widget _buildIconOnly() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFF00ADB5).withOpacity(0.1),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.3)),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: size * 0.6,
          height: size * 0.6,
          fit: BoxFit.contain,
          color: color,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.shopping_cart_rounded,
              size: size * 0.5,
              color: color ?? Color(0xFF00ADB5),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextOnly() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'BMG Corp',
          style: TextStyle(
            color: color ?? Color(0xFF00ADB5),
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        if (showText)
          Text(
            'نظام الإدارة',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: size * 0.2,
              fontFamily: 'Cairo',
            ),
          ),
      ],
    );
  }

  Widget _buildFullLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIconOnly(),
            SizedBox(width: size * 0.3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BMG Corp',
                  style: TextStyle(
                    color: color ?? Color(0xFF00ADB5),
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                if (showText)
                  Text(
                    'نظام إدارة التسويق',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: size * 0.2,
                      fontFamily: 'Cairo',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

enum LogoType {
  iconOnly,
  textOnly,
  full,
}