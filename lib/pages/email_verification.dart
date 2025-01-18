import 'package:flutter/material.dart';
import 'package:userapp/pages/edit_profile.dart';
import 'package:userapp/resources/constant_colors.dart';
import 'package:userapp/resources/text_style.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantsColors.CorPrinciapal,
      ),
      body: Center(
        child: Text('Verifique seu email para continuar',
            style: TextStylesConstants.kformularyText, textAlign: TextAlign.center, ),
      ),
    );
  }
}
