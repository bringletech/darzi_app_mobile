import 'package:darzi/common/widgets/customer/common_text_Field/commont_text_field.dart';
import 'package:darzi/homePage.dart';
import 'package:darzi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_customer_response_model.dart';
import 'package:darzi/apiData/model/update_customer_profile.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/all_text_form_field_profile.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/common/widgets/customer/common_app_bar_customer_without_back.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CustomerProfilePage extends StatefulWidget {
  final Locale locale;
  CustomerProfilePage({super.key, required this.locale});


  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isPressed = false;
  String userMobile = "";
  String userNameUpdate = "";
  String userAddress = "";

  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController profileMobileNoController = TextEditingController();
  final TextEditingController profileAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSharedPreferenceValue();
  }

  Future<void> getSharedPreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userMobile = prefs.getString('userMobileNumber') ?? '';
    profileMobileNoController.text = userMobile;
    await userUpdateDetails();
  }

  Future<void> userUpdateDetails() async {
    setState(() => isLoading = true);

    try {
      Current_Customer_response_Model model = await CallService().getCurrentCustomerDetails();
      setState(() {
        userNameUpdate = model.data?.name ?? '';
        userAddress = model.data?.address ?? '';
        profileNameController.text = userNameUpdate;
        profileAddressController.text = userAddress;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error fetching customer details.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
     // Fluttertoast.showToast(msg: "Error fetching customer details.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> callCustomerOtpVerifyApi(String userName, String address) async {
    setState(() => isLoading = true);

    try {
      var map = {'name': userName, 'address': address};
      Update_Customer_Profile_response_Model model = await CallService().customerUpdateProfile(map);

      setState(() {
        userNameUpdate = model.data?.name ?? '';
        userAddress = model.data?.address ?? '';
        profileNameController.text = userNameUpdate;
        profileAddressController.text = userAddress;
      });
      Fluttertoast.showToast(
          msg: model.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error updating profile.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      Fluttertoast.showToast(msg: "Error updating profile.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarCustomerWithOutBack(
        title: AppLocalizations.of(context)!.yourAccount,
        hasBackButton: true,
        elevation: 2.0,
        leadingIcon: SvgPicture.asset(
          'assets/svgIcon/account.svg',
          color: Colors.black,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.darkRed))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSectionLabel(AppLocalizations.of(context)!.userName),
              AllProfileTextFormField(
                mController: profileNameController,
                readOnly: false,
                hintText: '',
              ),
              const SizedBox(height: 20),
              _buildSectionLabel(AppLocalizations.of(context)!.mobileNumber),
              _buildMobileNumberField(),
              const SizedBox(height: 20),
              _buildSectionLabel(AppLocalizations.of(context)!.userAddress),
              AllProfileTextFormField(
                mController: profileAddressController,
                readOnly: false,
                hintText: '',
              ),
              const SizedBox(height: 20),
              _buildSaveButton(context),
              SizedBox(height: 10,),
              SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red,width: 2)
                    ),
                    onPressed: (){
                      showCustomerAlertDialog(
                        context,
                        locale: widget.locale,
                        onChangeLanguage: (newLocale) {
                          // Handle the language change
                          print("Language changed to: ${newLocale.languageCode}");
                        },
                      );
                      // showCustomerAlertDialog(context);
                    },
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.userLogout,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: isPressed ? Colors.white : AppColors.primaryRed,
                          ),
                        ),
                        SizedBox(width: 3,),
                        SvgPicture.asset(
                          "assets/svgIcon/logout.svg",
                        ),
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        const SizedBox(width: 8),
        AllText(
          text: text,
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildMobileNumberField() {
    return Material(
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        readOnly: true,
        controller: profileMobileNoController,
        decoration: InputDecoration(
          hintText: userMobile,
          contentPadding: const EdgeInsets.only(left: 15.0),
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            color: Color(0xff454545),
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    bool isPressed = false;
    return GestureDetector(
      onTap: () {
        String userName = profileNameController.text.trim();
        String address = profileAddressController.text.trim();
        callCustomerOtpVerifyApi(userName, address);
      },
      child: Container(
        width: 350,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPressed
                ? AppColors.Gradient1
                : [Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primaryRed, width: 2),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.saveDetails,
                style: TextStyle(
                  color: isPressed ? Colors.white : AppColors.primaryRed,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomerAlertDialog(BuildContext context, {required Locale locale, required Function(Locale) onChangeLanguage}) {
    // TextEditingController not needed as the dialog doesn't involve text input

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog (
          backgroundColor: Colors.white,
          title: Container(
              margin:  const EdgeInsets.only(left: 16),
              child: Text(AppLocalizations.of(context)!.logOutConfirmation,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Poppins',fontSize: 20),)),
          content:  Container(
            //margin:  const EdgeInsets.only(left: 16),
              child: Text(AppLocalizations.of(context)!.logOutConfirmationMessage,style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'Inter',fontSize: 16,color: Colors.grey))),
          actions: [
            Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(40),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: Colors.red), // Styled like in the 3rd function
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.red,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextButton(
                      style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.remove("userId");
                        await prefs.remove('userMobileNumber');
                        await prefs.remove('phoneNumber');
                        await prefs.remove("userToken");
                        await prefs.remove("userType");
                        await prefs.remove("selectedLanguage");
                        await prefs.clear();
                        // print("SharedPreference value are $prefs");
                        await Future.delayed(const Duration(seconds: 2));
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage(onChangeLanguage: onChangeLanguage)),
                              (route) => false, // Remove all previous routes
                        );
                        // Navigator.of(context, rootNavigator: true)
                        //     .pushAndRemoveUntil(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //       return HomePage(onChangeLanguage: onChangeLanguage);
                        //     },
                        //   ),
                        //       (_) => false,
                        // );
                      },
                      child:  Text(
                        AppLocalizations.of(context)!.yesMessage,
                        style: TextStyle(
                            color:
                            Colors.white), // Styled like in the 3rd function
                      ),
                    ),
                  ),
                ),

              ]),
            ),
          ],
        );
      },
    );
  }
}