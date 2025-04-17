import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/all_urls/all_urls.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/all_text_form_field_profile.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_without_back.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../homePage.dart';
import '../../../../../main.dart';

class TailorProfilePage extends StatefulWidget {
  final Locale locale;
  TailorProfilePage({super.key, required this.locale});

  @override
  State<TailorProfilePage> createState() => _TailorProfilePageState();
}

class _TailorProfilePageState extends State<TailorProfilePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController profileMobileNoController =
  TextEditingController();
  final TextEditingController profileAddressController =
  TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String mobileNumber = "", fileName = "";
  bool isLoading = false;
  bool isPressed = false;
  String enterName = "", address = "";
  String? profileUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading == true;
    getSharedValue();
    //userUpdateDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mobileNumber.isEmpty) {
      // or else you end up creating multiple instances in this case.
      getSharedValue();
    }
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.black),
              title: Text(
                AppLocalizations.of(context)!.appCamera,
              ),
              onTap: () async {
                final XFile? photo =
                await _picker.pickImage(source: ImageSource.camera);
                final CroppedFile? croppedFile = await ImageCropper()
                    .cropImage(sourcePath: photo!.path, uiSettings: [
                  AndroidUiSettings(
                    toolbarTitle: AppLocalizations.of(context)!.cropImage,
                    toolbarColor: Colors.deepOrange,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.ratio3x2,
                    lockAspectRatio: false,
                  ),
                  IOSUiSettings(
                    title: AppLocalizations.of(context)!.cropImage,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio4x3,
                      //CropAspectRatioPresetCustom(),
                    ],
                  ),
                ]);

                if (croppedFile != null) {
                  setState(() {
                    _selectedImage = File(croppedFile.path);
                    print("image value is $_selectedImage");
                  });
                } // Close the sheet
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.black),
              title: Text(
                AppLocalizations.of(context)!.appGallery,
              ),
              onTap: () async {
                final XFile? photo =
                await _picker.pickImage(source: ImageSource.gallery);
                if (photo == null) return; // If no image selected

                // Crop the image
                final CroppedFile? croppedFile = await ImageCropper()
                    .cropImage(sourcePath: photo.path, uiSettings: [
                  AndroidUiSettings(
                    toolbarTitle: AppLocalizations.of(context)!.cropImage,
                    toolbarColor: Colors.deepOrange,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.ratio3x2,
                    lockAspectRatio: false,
                  ),
                  IOSUiSettings(
                    title: AppLocalizations.of(context)!.cropImage,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio4x3,
                      //CropAspectRatioPresetCustom(),
                    ],
                  ),
                ]);

                if (croppedFile != null) {
                  setState(() {
                    _selectedImage = File(croppedFile.path);
                    print("image value is $_selectedImage");
                  });
                }
                Navigator.pop(context); // Close the sheet
              },
            ),
          ],
        );
      },
    );
  }

  void updateUI() {
    setState(() {});
  }

  void userUpdateDetails() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Current_Tailor_Response model =
        await CallService().getCurrentTailorDetails();
        setState(() {
          isLoading = false;
          enterName = model.data?.name ?? "";
          address = model.data?.address ?? "";
          profileUrl = model.data?.profileUrl ?? ""; // Null check fix
          print("name Value is: $enterName");
          print("name Value is: $address");
          print("Profile URL: $profileUrl");
          profileNameController.text = enterName;
          profileAddressController.text = address;
        });
      });
    });
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
                locale: widget.locale,
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
            appBar: CustomAppBarWithOutBack(
              // title: 'Your Account',
              title: AppLocalizations.of(context)!.yourAccount,
              hasBackButton: true,
              elevation: 2.0,
              leadingIcon: SvgPicture.asset(
                'assets/svgIcon/account.svg',
              ),
            ),
            body: isLoading == true
                ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.darkRed,
                ))
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SafeArea(
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var cameraStatus =
                              await Permission.camera.request();
                              if (cameraStatus.isGranted) {
                                _showImageSourceActionSheet(context);
                              } else {
                                print("Camera permission denied");
                              }
                            },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: _selectedImage != null
                                    ? Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                )
                                    : (profileUrl!= null &&
                                    profileUrl!.isNotEmpty)
                                    ? CachedNetworkImage(
                                  height: 120,
                                  width: 120,
                                  imageUrl: profileUrl!,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context,
                                      url,
                                      downloadProgress) =>
                                      CircularProgressIndicator(
                                        value: downloadProgress
                                            .progress,
                                        color: Colors.red,
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                      Icon(Icons.error),
                                )
                                    : SvgPicture.asset(
                                  'assets/svgIcon/profilepic.svg', // Default profile icon
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                          ),

                          // Edit Button
                          GestureDetector(
                            onTap: () async {
                              var cameraStatus =
                              await Permission.camera.request();
                              if (cameraStatus.isGranted) {
                                print(
                                    "Camera and Gallery permission granted");
                                _showImageSourceActionSheet(context);
                              } else {
                                print("Camera permission denied");
                              }
                            },
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Transform.translate(
                                offset: Offset(0, 15),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 5, left: 40, right: 40, bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 8),
                            AllText(
                              text:
                              AppLocalizations.of(context)!.userName,
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Material(
                          elevation: 10,
                          shadowColor: Colors.black.withOpacity(1.0),
                          borderRadius: BorderRadius.circular(30),
                          child: TextFormField(
                            readOnly: false,
                            controller: profileNameController,
                            decoration: InputDecoration(
                              hintText: '',
                              contentPadding: EdgeInsets.only(left: 15.0),
                              hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  color: Color(0xff454545),
                                  fontWeight: FontWeight.w400),

                              //contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 8),
                            AllText(
                              text: AppLocalizations.of(context)!
                                  .mobileNumber,
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Material(
                          elevation: 10,
                          shadowColor: Colors.black.withOpacity(1.0),
                          borderRadius: BorderRadius.circular(30),
                          child: TextFormField(
                            readOnly: true,
                            controller: profileMobileNoController,
                            decoration: InputDecoration(
                              hintText: mobileNumber,
                              contentPadding: EdgeInsets.only(left: 15.0),
                              hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  color: Color(0xff454545),
                                  fontWeight: FontWeight.w400),

                              //contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 8),
                            AllText(
                              text: AppLocalizations.of(context)!
                                  .userAddress,
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        AllProfileTextFormField(
                          readOnly: false,
                          hintText: '',
                          // hintText: address.isEmpty
                          //     ? StringConstant.address
                          //     : address,
                          mController: profileAddressController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildSignUpButton(context),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 350,
                          height: 60,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                      color: Colors.red, width: 2)),
                              onPressed: () {
                                // showAlertDialog(context,locale: widget.locale);
                                showAlertDialog(
                                  context,
                                  locale: widget.locale,
                                  onChangeLanguage: (newLocale) {
                                    // Handle the language change
                                    print(
                                        "Language changed to: ${newLocale.languageCode}");
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .userLogout,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19,
                                      color: isPressed
                                          ? Colors.white
                                          : AppColors.primaryRed,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  SvgPicture.asset(
                                    "assets/svgIcon/logout.svg",
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    bool isPressed = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () async {
            if (_selectedImage != null) {
              isLoading = true;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? accessToken = prefs.getString('userToken')!;
              print("Access Token is $accessToken");
              Uri url =
              Uri.parse('$apiImageBaseUrl/tailor/updateTailorDetails');
              print("Url is $url");
              var request = http.MultipartRequest('PUT', url);
              request.headers['accept'] = "application/json";
              request.headers['Authorization'] = "Bearer $accessToken";
              request.fields["name"] = profileNameController.text.toString();
              request.fields["address"] =
                  profileAddressController.text.toString();
              var image = await http.MultipartFile.fromPath(
                'profileUrl',
                _selectedImage!.absolute.path,
              );
              print("image value is ${image.toString()}");
              request.files.add(image);
              request.headers['Content-Type'] = 'multipart/form-data';
              print("user profile requestttttttt");
              print(request.fields);
              var streamedResponse = await request.send();
              var response = await http.Response.fromStream(streamedResponse);
              print("Response is $response");
              print(response.body);
              print("Response code is: ${response.statusCode}");
              if (response.statusCode == 200) {
                isLoading = false;
                print("uploaded user profile imagesssss");
                var jsonbody = jsonDecode(response.body);
                print(response.body);
                Fluttertoast.showToast(
                    msg: jsonbody['message'].toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
                fileName = "";
                updateUI();
                userUpdateDetails();
              }
            } else {
              isLoading = true;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? accessToken = prefs.getString('userToken')!;
              print("Access Token is $accessToken");
              Uri url =
              Uri.parse('$apiImageBaseUrl/tailor/updateTailorDetails');
              print("Url is $url");
              var request = http.MultipartRequest('PUT', url);
              request.headers['accept'] = "application/json";
              request.headers['Authorization'] = "Bearer $accessToken";
              request.fields["name"] = profileNameController.text.toString();
              request.fields["address"] =
                  profileAddressController.text.toString();
              request.headers['Content-Type'] = 'multipart/form-data';
              print("user profile requestttttttt");
              print(request.fields);
              var streamedResponse = await request.send();
              var response = await http.Response.fromStream(streamedResponse);
              print("Response is $response");
              print(response.body);
              print("Response code is: ${response.statusCode}");
              if (response.statusCode == 200) {
                isLoading = false;
                print("uploaded user profile imagesssss");
                var jsonbody = jsonDecode(response.body);
                print(response.body);
                Fluttertoast.showToast(
                    msg: jsonbody['message'].toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
                fileName = "";
                updateUI();
                userUpdateDetails();
              }
            }
          },
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) async {},
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
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
      },
    );
  }

  void getSharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString('userMobileNumber').toString();
    print("User Mobile Number Value is : $mobileNumber");
    userUpdateDetails();
  }

  void showAlertDialog(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(context)!.logOutConfirmation,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 20),
            ),
          ),
          content: Container(
            child: Text(
              AppLocalizations.of(context)!.logOutConfirmationMessage,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: Colors.red),
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
                      onPressed: () async {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
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
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(onChangeLanguage: onChangeLanguage)),
                              (route) => false, // Remove all previous routes
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.yesMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}