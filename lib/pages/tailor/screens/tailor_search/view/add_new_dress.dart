import 'dart:convert';
import 'dart:io';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/all_text_form_field.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../apiData/all_urls/all_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddNewDress extends StatefulWidget {
  final BuildContext context;
  final String customerId;
  final Locale locale;
  const AddNewDress(this.context,this.customerId,this.locale, {super.key});

  @override
  State<AddNewDress> createState() => _AddNewDressState();
}

class _AddNewDressState extends State<AddNewDress> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController dressNameController = TextEditingController();
  final TextEditingController stitchingCostController = TextEditingController();
  final TextEditingController advancedCostController = TextEditingController();
  final TextEditingController outStandingBalancedController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  String formattedDate = "",customerId = "";
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isImageSelected = false;
  bool isPressed = false;



  @override
  void dispose() {
    stitchingCostController.removeListener(calculateOutstandingBalance);
    advancedCostController.removeListener(calculateOutstandingBalance);
    stitchingCostController.dispose();
    advancedCostController.dispose();
    outStandingBalancedController.dispose();
    super.dispose();
  }

  // Method to calculate outstanding balance
  void calculateOutstandingBalance() {
    double stitchingCost = double.tryParse(stitchingCostController.text) ?? 0.0;
    double advance = double.tryParse(advancedCostController.text) ?? 0.0;
    double outstanding = stitchingCost - advance;

    outStandingBalancedController.text = outstanding.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    stitchingCostController.addListener(calculateOutstandingBalance);
    advancedCostController.addListener(calculateOutstandingBalance);
    setState(() {
      customerId = widget.customerId.toString();
      print("CustomerId is $customerId");
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? shouldPop = await showWarningMessage(context,locale: widget.locale,
          onChangeLanguage: (newLocale) {
            // Handle the language change
            print(
                "Language changed to: ${newLocale.languageCode}");
          },);
        return shouldPop ?? false;
      },
      child: Container(
        color: Colors.white,
        child: Scaffold(
          appBar: CustomAppBarWithBack(
            title: AppLocalizations.of(context)!.addNewDress,
            hasBackButton: true,
            leadingIcon: SvgPicture.asset(
              'assets/svgIcon/add.svg',
            ),
            onBackButtonPressed: () async {
              bool? shouldPop = await showWarningMessage(context,locale: widget.locale,
                onChangeLanguage: (newLocale) {
                  // Handle the language change
                  print(
                      "Language changed to: ${newLocale.languageCode}");
                },);
              print("pop up value is $shouldPop");
              if (shouldPop == true) {
                Navigator.pop(context);
              }
              //Navigator.pop(widget.context);
            },
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: AllText(
                            text: AppLocalizations.of(context)!.dressName,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(width: 8),
                    Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          child: AllTextFormField(
                            inputType: TextInputType.text,
                            hintText: AppLocalizations.of(context)!.enterDressName,
                            mController: dressNameController,
                            readOnly: false,
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Label
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)!.dressPhoto,
                          style: TextStyle(
                            fontFamily: 'Popins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          child: GestureDetector(
                            onTap: () async {
                              var cameraStatus = await Permission.camera.request();
                              if(cameraStatus.isGranted) {
                                _showImageSourceActionSheet(context);
                              }
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 4.0,
                                    blurRadius: 4.0,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      AppLocalizations.of(context)!.addImage,
                                      style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Icon(Icons.add_circle_outline_sharp,
                                        size: 15, color: Colors.red
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (_isImageSelected)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: AllText(
                              text: AppLocalizations.of(context)!.dueDate,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 8),
                      Expanded(
                          flex: 3,
                          child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  print("Field is tapped");
                                });
                              },
                              child: Material(
                                  elevation: 10,
                                  shadowColor: Colors.black.withOpacity(1.0),
                                  borderRadius: BorderRadius.circular(30),
                                  child: TextFormField(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        print(pickedDate);
                                        formattedDate = DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                        print("Date Value is : $formattedDate");
                                        setState(() {
                                          dueDateController.text =
                                              formattedDate; //set output date to TextField value.
                                        });
                                        value:
                                        formattedDate;
                                      }
                                    },
                                    readOnly: true,
                                    controller: dueDateController,
                                    decoration: InputDecoration(
                                      hintText: formattedDate.isEmpty
                                          ? AppLocalizations.of(context)!.noDateSelected
                                          : formattedDate.toString(),
                                      contentPadding: EdgeInsets.only(left: 15.0),
                                      hintStyle: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          color: Color(0xff454545),
                                          fontWeight: FontWeight.w400),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ))))
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: AllText(
                              text: AppLocalizations.of(context)!.stitchingCost1,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 8),
                      Expanded(
                          flex: 3,
                          child: AllTextFormField(
                            inputType: TextInputType.number,
                            hintText: '₹',
                            mController: stitchingCostController,
                            readOnly: false,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: AllText(
                              text: AppLocalizations.of(context)!.advancedCost,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 8),
                      Expanded(
                          flex: 3,
                          child: AllTextFormField(
                            inputType: TextInputType.number,
                            hintText: '₹',
                            mController: advancedCostController,
                            readOnly: false,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: AllText(
                              text: AppLocalizations.of(context)!.outstandingBalance1,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 8),
                      Expanded(
                          flex: 3,
                          child: AllTextFormField(
                            inputType: TextInputType.number,
                            hintText: '₹',
                            mController: outStandingBalancedController,
                            readOnly: false,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  // onTap: () async {
                  //   //isLoading = true;
                  //   SharedPreferences prefs = await SharedPreferences
                  //       .getInstance();
                  //   String? accessToken = prefs.getString('userToken')!;
                  //   print("Access Token is $accessToken");
                  //   Uri url = Uri.parse('$apiImageBaseUrl/order/addNewOrder');
                  //   print("Url is $url");
                  //   var request = http.MultipartRequest('POST', url);
                  //   request.headers['accept'] = "application/json";
                  //   request.headers['Authorization'] = "Bearer $accessToken";
                  //   request.fields["customerId"] = customerId;
                  //   request.fields["dueDate"] = formattedDate;
                  //   request.fields["dressName"] =
                  //       dressNameController.text.toString();
                  //   request.fields["stitchingCost"] =
                  //       stitchingCostController.text.toString();
                  //   request.fields["advanceReceived"] =
                  //       advancedCostController.text.toString();
                  //   request.fields["outstandingBalance"] =
                  //       outStandingBalancedController.text.toString();
                  //   var image = await http.MultipartFile.fromPath(
                  //     'dressImgUrl',
                  //     _selectedImage!.absolute.path,
                  //   );
                  //   print("image value is ${image.toString()}");
                  //   request.files.add(image);
                  //   request.headers['Content-Type'] = 'multipart/form-data';
                  //   print("user profile requestttttttt");
                  //   print(request.fields);
                  //   var streamedResponse = await request.send();
                  //   var response = await http.Response.fromStream(
                  //       streamedResponse);
                  //   print("Response is $response");
                  //   print(response.body);
                  //   print("Response code is: ${response.statusCode}");
                  //   if (response.statusCode == 200) {
                  //     //isLoading = false;
                  //     print("uploaded user profile imagesssss");
                  //     var jsonbody = jsonDecode(response.body);
                  //     print(response.body);
                  //     Fluttertoast.showToast(
                  //         msg: jsonbody['message'].toString(),
                  //         toastLength: Toast.LENGTH_SHORT,
                  //         gravity: ToastGravity.CENTER,
                  //         timeInSecForIosWeb: 1,
                  //         backgroundColor: Colors.black,
                  //         textColor: Colors.white,
                  //         fontSize: 16.0);
                  //     dressNameController.clear();
                  //     dueDateController.clear();
                  //     stitchingCostController.clear();
                  //     advancedCostController.clear();
                  //     outStandingBalancedController.clear();
                  //     _selectedImage = null;
                  //     // fileName = "";
                  //     // updateUI();
                  //     // userUpdateDetails();
                  //   }
                  // },
                  onTap: () async {
                    // Check if any field is empty
                    if (dressNameController.text.isEmpty ||
                        dueDateController.text.isEmpty ||
                        stitchingCostController.text.isEmpty ||
                        advancedCostController.text.isEmpty ||
                        outStandingBalancedController.text.isEmpty ||
                        !_isImageSelected) {
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.validationMessage,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    String? accessToken = prefs.getString('userToken')!;
                    print("Access Token is $accessToken");
                    Uri url = Uri.parse('$apiImageBaseUrl/order/addNewOrder');
                    print("Url is $url");
                    var request = http.MultipartRequest('POST', url);
                    request.headers['accept'] = "application/json";
                    request.headers['Authorization'] = "Bearer $accessToken";
                    request.fields["customerId"] = customerId;
                    request.fields["dueDate"] = formattedDate;
                    request.fields["dressName"] =
                        dressNameController.text.toString();
                    request.fields["stitchingCost"] =
                        stitchingCostController.text.toString();
                    request.fields["advanceReceived"] =
                        advancedCostController.text.toString();
                    request.fields["outstandingBalance"] =
                        outStandingBalancedController.text.toString();

                    if (_selectedImage != null) {
                      var image = await http.MultipartFile.fromPath(
                        'dressImgUrl',
                        _selectedImage!.absolute.path,
                      );
                      print("image value is ${image.toString()}");
                      request.files.add(image);
                    }

                    request.headers['Content-Type'] = 'multipart/form-data';
                    print("user profile requestttttttt");
                    print("user profile requestttttttt ${request.fields}");

                    var streamedResponse = await request.send();
                    var response =
                    await http.Response.fromStream(streamedResponse);
                    print("Response is $response");
                    print(response.body);
                    print("Response code is: ${response.statusCode}");

                    if (response.statusCode == 200) {
                      var jsonbody = jsonDecode(response.body);
                      print(response.body);
                      Fluttertoast.showToast(
                        msg: jsonbody['message'].toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      // Clear fields and image selection
                      setState(() {
                        formattedDate = "";
                        dressNameController.clear();
                        dueDateController.clear();
                        stitchingCostController.clear();
                        advancedCostController.clear();
                        outStandingBalancedController.clear();
                        _selectedImage = null;
                        _isImageSelected = false; // Reset the flag
                      });
                    }
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
                      border: Border.all(
                          color: AppColors.primaryRed,
                          width: 2),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.saveDetails1,
                            style: TextStyle(
                              color: isPressed
                                  ? Colors.white
                                  : AppColors.primaryRed,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
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
              title: Text(AppLocalizations.of(context)!.appCamera),
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
                    _isImageSelected = true;
                    print("image value is $_selectedImage");
                  });
                } // Close the sheet
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.black),
              title: Text(AppLocalizations.of(context)!.appGallery),
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
                    _isImageSelected = true;
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

  // ✅ Warning Dialog Function
  Future<bool?> showWarningMessage(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(context)!.unsaved_changes,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 20),
            ),
          ),
          content: Container(
            child: Text(
              AppLocalizations.of(context)!.unsaved_changes_warningMessage,
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
                      onPressed: () {
                        Navigator.of(context).pop(true);// Close dialog and return true
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
    ) ?? false; // Agar null return ho to false return karo
  }
}