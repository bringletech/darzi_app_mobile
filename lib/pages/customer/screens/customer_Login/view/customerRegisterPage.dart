import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/login_model.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/main.dart';
import 'package:darzi/pages/customer/screens/Customer_Otp_Verification/view/customer_otp_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Ensure this import is correct


class CustomerregisterpagePage extends StatefulWidget {
  Locale locale; // Receive Locale

  CustomerregisterpagePage({super.key, required this.locale});

  @override
  State<CustomerregisterpagePage> createState() => _CustomerregisterpagePageState();
}

class _CustomerregisterpagePageState extends State<CustomerregisterpagePage> {
  FocusNode focusNode = FocusNode();
  bool rememberMe = false,
      isLoading = false,isSelected = false;
  String phoneNumber = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _changeLanguage(widget.locale);
    print("Current Locale in OTP Screen: ${widget.locale.languageCode}");
  }


  void _changeLanguage(Locale locale) {
    setState(() {
      widget.locale = locale; // Update the locale
      // Notify the app to rebuild with the new locale
      WidgetsBinding.instance.addPostFrameCallback((_) {
        MyApp.of(context)?.setLocale(locale); // Update the locale dynamically
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      //backgroundColor: Colors.red[50], // Background color with a light red tint
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Avatar image and background circles
              Container(
                padding: EdgeInsets.only(top: 50,left: 22),
                constraints: BoxConstraints(maxHeight: 320),
                //height: 400,
                // constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height,),
                //maxHeight: MediaQuery.of(context).size.height,),
                child: Image.asset('assets/images/Darzilogin.png',
                  // fit :BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20), // Increased space after the image
              // "Login or Signup" text
              Text(
                AppLocalizations.of(context)!.login,
                style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,fontSize: 20,),
              ),
              const SizedBox(height: 20),
              // Form section with phone number and agreement
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Ensures the Column takes only as much space as needed
                      children: [
                        // Phone number input with country code
                        IntlPhoneField(
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .phoneNumber,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          languageCode: "en",
                          showCountryFlag: true,
                          initialCountryCode: 'IN',
                          onChanged: (phone) async {
                            phoneNumber = phone.number.toString();
                            print("Phone Number Value is : ${phoneNumber}");
                          },
                          onCountryChanged: (country) {
                            print('Country changed to: ' + country.name);
                          },
                        ),
                        // const SizedBox(height: 10),
                        // Agreement and checkboxes
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              //value: true,
                              value: rememberMe,
                              activeColor: Colors.red, // Red checkbox color
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                  print("Check value is : $rememberMe");
                                  if(rememberMe == true)
                                  {
                                    callCustomerLoginApi(phoneNumber);
                                  }else if(phoneNumber.isEmpty){
                                  }else{
                                    Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)!
                                            .agreeContinue,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                });
                              },
                            ),
                            // Expanded(
                            //   child: Wrap(
                            //     children: [
                            //       const Text(StringConstant.agreeContinue,
                            //         style: TextStyle(
                            //             fontFamily: 'Poppins',
                            //             fontWeight: FontWeight.w400,
                            //             fontSize: 12
                            //         ),),
                            //       GestureDetector(
                            //         onTap: () {},
                            //         // Navigate to Terms of Service
                            //         child: const Text(
                            //           StringConstant.termsOfService,
                            //           style: TextStyle(
                            //             fontFamily: 'Poppins',
                            //             fontWeight: FontWeight.w400,
                            //             fontSize: 12,
                            //             color: Colors.red,
                            //             // Red underline text
                            //             decoration: TextDecoration.underline,
                            //             decorationColor: Colors.red,
                            //           ),
                            //         ),
                            //       ),
                            //       const Text(", ",
                            //         style: TextStyle(color: Colors.red,),),
                            //       GestureDetector(
                            //         onTap: () {}, // Navigate to Privacy Policy
                            //         child: const Text(
                            //           StringConstant.privacyPolicy,
                            //           style: TextStyle(
                            //             fontFamily: 'Poppins',
                            //             fontWeight: FontWeight.w400,
                            //             fontSize: 12,
                            //             color: Colors.red,
                            //             // Red underline text
                            //             decoration: TextDecoration.underline,
                            //             decorationColor: Colors.red,
                            //           ),
                            //         ),
                            //       ),
                            //       const Text(
                            //         StringConstant.and, style: TextStyle(
                            //         fontFamily: 'Poppins',
                            //         fontWeight: FontWeight.w400,
                            //         fontSize: 12,
                            //         color: Colors.black, // Red underline text
                            //       ),),
                            //       GestureDetector(
                            //         onTap: () {}, // Navigate to Content Policy
                            //         child: const Text(
                            //           StringConstant.contentPolicy,
                            //           style: TextStyle(
                            //             fontFamily: 'Poppins',
                            //             fontWeight: FontWeight.w400,
                            //             fontSize: 12,
                            //             color: Colors.red,
                            //             // Red underline text
                            //             decoration: TextDecoration.underline,
                            //             decorationColor: Colors.red,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Expanded(
                              child: Wrap(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!.agreeContinue, // "I Agree & Continue "
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!.termsOfService, // "Terms of Service"
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.red, // Highlight color
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to Terms of Service
                                              print('Terms of Service clicked');
                                            },
                                        ),
                                        TextSpan(
                                          text: " , ",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                          // Separator text
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!.privacyPolicy, // "Privacy Policy"
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.red,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to Privacy Policy
                                              print('Privacy Policy clicked');
                                            },
                                        ),
                                        TextSpan(
                                          text: " ${AppLocalizations.of(context)!.and} ", // Localized "and"
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!.contentPolicy, // "Content Policy"
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.red,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to Content Policy
                                              print('Content Policy clicked');
                                            },
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Agree and continue button
                      ],
                    ),
                  ),
                ),
              ),
              //const SizedBox(height: 30), // Add some space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  void callCustomerLoginApi(String phoneNumber) {
    var map = Map<String, dynamic>();
    map['mobileNo'] = phoneNumber;
    print("Map value is$map");
    isLoading = true;
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      LoginResponseModel model =
      await CallService()
          .customerLogin(map);
      isLoading = false;
      String message = model.message.toString();
      showCustomToast(context, message, 10);
      // Fluttertoast.showToast(
      //     msg: message,
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerOtpVerificationPage(phoneNumber,locale: widget.locale)),
      );
    });
  }


  void showCustomToast(BuildContext context, String message, int durationInSeconds) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove toast after the given duration
    Future.delayed(Duration(seconds: durationInSeconds), () {
      overlayEntry.remove();
    });
  }

}
