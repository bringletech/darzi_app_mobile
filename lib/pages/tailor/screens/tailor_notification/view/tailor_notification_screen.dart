import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/notification_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/customer/common_text_Field/commont_text_field.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/darzi_home_screen.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:darzi/pages/tailor/screens/tailor_notification/view/user_profile_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TailorNotificationScreen extends StatefulWidget {
  final Locale? locale;
  const TailorNotificationScreen({super.key, this.locale});

  @override
  State<TailorNotificationScreen> createState() =>
      _TailorNotificationScreenState();
}

class _TailorNotificationScreenState extends State<TailorNotificationScreen> {
  List<NotificationData>? notificationData = [];
  bool isLoading = false;
  int? selectedNotificationIndex;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTailorNotification();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to TailorDashboardNew when device back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TailorDashboardNew(
                locale: widget.locale!,
              )),
        );
        return false; // Prevent default back behavior
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBarWithBack(
            title: AppLocalizations.of(context)!.application_notifications,
            hasBackButton: true,
            elevation: 2.0,
            onBackButtonPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TailorDashboardNew(
                      locale: widget.locale!,
                    )),
              );
              Navigator.pop(context, true);
            },
          ),
          body: isLoading
              ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryRed,
              ))
              : notificationData == null || notificationData!.isEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/no_results.png",
                height: 80,
              ),
              Center(
                child: Text(
                    AppLocalizations.of(context)!
                        .no_notification_message,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
              ),
            ],
          )
              : Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: notificationData!.length,
                itemBuilder: (context, index) {
                  final item = notificationData![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              selectedNotificationIndex = index; // set selected index
                            });

                            // Navigate to next screen (replace with your own screen)
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileReview(notificationId:item.id.toString(),locale: widget.locale),
                              ),
                            );

                            // When you return from next screen, the selected item stays highlighted
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: item.isViewed==false?AppColors.notificationBackgroundColour:Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.25),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.message.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12, color: Colors.black54),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item.time.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getTailorNotification() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        NotificationResponseModel model = await CallService().getNotification();
        setState(() {
          isLoading = false;
          notificationData = model.data;
          print('Notification Data Length is :$notificationData');
        });
      });
    });
  }
}
