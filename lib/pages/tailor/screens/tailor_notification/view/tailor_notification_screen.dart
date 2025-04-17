import 'package:darzi/common/widgets/customer/common_text_Field/commont_text_field.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TailorNotificationScreen extends StatefulWidget {
  final Locale? locale;
  const TailorNotificationScreen({super.key,this.locale});

  @override
  State<TailorNotificationScreen> createState() => _TailorNotificationScreenState();
}

class _TailorNotificationScreenState extends State<TailorNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Color(0xFFD5D5D5),
        appBar:  CustomAppBarWithBack(
          title: AppLocalizations.of(context)!.application_notifications,
          hasBackButton: true,
          elevation: 2.0,
          onBackButtonPressed: (){
            Navigator.pop(context);
          },
        ),
        body: Container(
          color: Colors.white,
            child: buildNotificationFields(widget.locale)),
      ),
    );
  }
}