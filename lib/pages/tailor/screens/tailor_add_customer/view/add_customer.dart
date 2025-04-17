import 'dart:convert';
import 'dart:io';
import 'package:darzi/common/widgets/tailor/custom_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../../apiData/all_urls/all_urls.dart';
import '../../../../../apiData/call_api_service/call_service.dart';
import '../../../../../apiData/model/verify_mobile_model.dart';
import '../../../../../colors.dart';
import '../../../../../common/all_text.dart';
import '../../../../../common/all_text_form_field.dart';
import '../../../../../common/widgets/tailor/commAddCustTextField.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';
import '../../tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddCustomer extends StatefulWidget {
  final Locale locale;
  AddCustomer({super.key, required this.locale,});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  bool isPressed = false;
  bool selectValue = false;
  bool isLoading = false;
  String optional = "inch", message = "";
  final FocusNode _focusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController dressNameController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController neckController = TextEditingController();
  final TextEditingController bustController = TextEditingController();
  final TextEditingController underBustController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipsController = TextEditingController();
  final TextEditingController neckToAboveKneeController = TextEditingController();
  final TextEditingController armLengthController = TextEditingController();
  final TextEditingController shoulderSeamController = TextEditingController();
  final TextEditingController armHoleController = TextEditingController();
  final TextEditingController bicepController = TextEditingController();
  final TextEditingController foreArmController = TextEditingController();
  final TextEditingController wristController = TextEditingController();
  final TextEditingController shoulderToWaistController = TextEditingController();
  final TextEditingController bottomLengthController = TextEditingController();
  final TextEditingController ankleController = TextEditingController();
  final TextEditingController stitchingCostController = TextEditingController();
  final TextEditingController advancedReceivedController = TextEditingController();
  final TextEditingController outStandingBalanceController = TextEditingController();
  TextEditingController textarea = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String formattedDate = "", fileName = "";
  String advancedCost = "00";

  @override
  void initState() {
    super.initState();
    stitchingCostController.addListener(calculateOutstandingBalance);
    advancedReceivedController.addListener(calculateOutstandingBalance);
  }

  @override
  void dispose() {
    stitchingCostController.removeListener(calculateOutstandingBalance);
    advancedReceivedController.removeListener(calculateOutstandingBalance);
    stitchingCostController.dispose();
    advancedReceivedController.dispose();
    outStandingBalanceController.dispose();
    super.dispose();
  }

  // Method to calculate outstanding balance
  void calculateOutstandingBalance() {
    double stitchingCost = double.tryParse(stitchingCostController.text) ?? 0;
    double advance = double.tryParse(advancedReceivedController.text) ?? 0;
    double outstanding = stitchingCost - advance;

    outStandingBalanceController.text = outstanding.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showWarningMessage(
          context,
          locale: widget.locale,
          onChangeLanguage: (newLocale) {
            // Handle the language change
            print("Language changed to: ${newLocale.languageCode}");
          },
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => TailorDashboardNew(locale: widget.locale,)),
        // );
        return false;
      },
      child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,),
          child: Scaffold(
              appBar: CustomAppBarWithBack(
                  title: AppLocalizations.of(context)!.newCustomer,
                  hasBackButton: true,
                  elevation: 2.0,
                  leadingIcon: SvgPicture.asset(
                    'assets/svgIcon/addCust.svg',
                    color: Colors.black,
                  ),
                  onBackButtonPressed: () async {
                    showWarningMessage(
                      context,
                      locale: widget.locale,
                      onChangeLanguage: (newLocale) {
                        // Handle the language change
                        print(
                            "Language changed to: ${newLocale.languageCode}");
                      },
                    );

                  }
              ),
              body: SingleChildScrollView(
                  child: Container(
                      color: Colors.white,
                      child: Column(
                          children: [
                            Container(
                                child: Card(
                                  color: Colors.white,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(borderRadius:
                                  BorderRadius.vertical(bottom: Radius.circular(40)),),
                                  child: Container(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                      flex: 2,
                                                      child: AllText(text: AppLocalizations.of(context)!.userName, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500,)),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                      flex: 3,
                                                      child: AllTextFormField(inputType: TextInputType.text, hintText: AppLocalizations.of(context)!.enterName, mController: nameController, readOnly: false,)
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: AllText(text: AppLocalizations.of(context)!.mobileNumber, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500,),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Material(elevation: 8, shadowColor: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(30),
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                onChanged: (value) => _checkInput(value),
                                                                readOnly: false,
                                                                focusNode: _focusNode,
                                                                controller: mobileNoController,
                                                                decoration: InputDecoration(
                                                                  hintMaxLines: 1,
                                                                  hintText: AppLocalizations.of(context)!.enterMobileNumber,
                                                                  contentPadding: EdgeInsets.only(left: 15.0),
                                                                  hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xff454545), fontWeight: FontWeight.w400,),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide.none,),
                                                                  filled: true,
                                                                  fillColor: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                            if (isLoading)
                                                              Positioned(
                                                                right: 8.0,
                                                                top: 12.0,
                                                                child: SizedBox(width: 24, height: 24,
                                                                  child: CircularProgressIndicator(strokeWidth: 2.0),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 3),
                                                        // Debugging Text
                                                        //Text("Current message: $message", style: TextStyle(color: Colors.red)),
                                                        if (message.contains("Number registered on Darzi App")&& message.isNotEmpty)
                                                          Container(
                                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                            decoration: BoxDecoration(
                                                              color: Colors.green.withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(10),
                                                              border: Border.all(color: Colors.green),
                                                            ),
                                                            child: Text(
                                                              message,
                                                              style: TextStyle(
                                                                fontFamily: 'Poppins',
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(flex: 2,
                                                      child: AllText(text: AppLocalizations.of(context)!.dressName, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500)),
                                                  SizedBox(width: 8),
                                                  Expanded(flex: 3,
                                                      child: AllTextFormField(inputType: TextInputType.text, hintText: AppLocalizations.of(context)!.enterDressName, mController: dressNameController, readOnly: false,)),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(flex: 2,
                                                    child: Text(AppLocalizations.of(context)!.dressPhoto, style: TextStyle(fontFamily: 'Popins', fontSize: 15, fontWeight: FontWeight.w500,),),),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                      flex: 3,
                                                      child: GestureDetector(onTap: () async {
                                                        var cameraStatus =
                                                        await Permission.camera.request();
                                                        //var galleryStatus = await Permission.storage.request();
                                                        if (cameraStatus.isGranted) {
                                                          print(
                                                              "Camera and Gallery permission granted");
                                                          _pickedImages(context);
                                                        }
                                                      },
                                                        child: Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(color: Colors.white,
                                                            borderRadius: BorderRadius.circular(25),
                                                            border: Border.all(color: Colors.white),
                                                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 4.0, blurRadius: 4.0, offset: const Offset(0, 3),),],),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                                                                child: Text(AppLocalizations.of(context)!.addImage, style: const TextStyle(fontFamily:'Inter',fontSize: 11,color:Colors.red, fontWeight: FontWeight.w400),),),
                                                              Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                                                                child: Icon(Icons.add_circle_outline_sharp, size: 15, color: Colors.red),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Visibility(
                                                visible: _selectedImage != null,
                                                child: Center(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 30),
                                                    child: Card(elevation: 4.0,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                                                      child: Column(
                                                        children: [
                                                          Container(child: _selectedImage == null
                                                              ? SvgPicture.asset('assets/svgIcon/profilepic.svg', width: 80, height: 80,)
                                                              : ClipOval(child: Image.file(_selectedImage!, fit: BoxFit.cover, width: 120, height: 120,
                                                          ),
                                                          ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(flex: 2,
                                                      child: AllText(text: AppLocalizations.of(context)!.dueDate, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500)),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    flex: 3,
                                                    child: GestureDetector(onTap: () async {setState(() {
                                                      print("Field is tapped");});
                                                    _pickedImages(context);},
                                                      child: Material(elevation: 10, shadowColor: Colors.black.withOpacity(1.0),
                                                        borderRadius: BorderRadius.circular(30),
                                                        child: TextFormField(
                                                          onTap: () async {
                                                            DateTime? pickedDate =
                                                            await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(),
                                                              lastDate: DateTime(2100),);
                                                            if (pickedDate != null) {
                                                              print(pickedDate);
                                                              formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                              print("Date Value is : $formattedDate");
                                                              setState(() {dueDateController.text = formattedDate;});
                                                              value:formattedDate;}
                                                          },
                                                          readOnly: true,
                                                          controller: dueDateController,
                                                          decoration: InputDecoration(
                                                            hintText:
                                                            formattedDate.isEmpty ? AppLocalizations.of(context)!.noDateSelected : formattedDate.toString(),
                                                            contentPadding: EdgeInsets.only(left: 15.0),
                                                            hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xff454545), fontWeight: FontWeight.w400),
                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none), filled: true, fillColor: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        ),)

                                  ),
                                )
                            ),
                            Container(
                                margin: EdgeInsets.all( 10),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15,),
                                      Text(
                                        AppLocalizations.of(context)!.howToMeasure,
                                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 15),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          AnimatedSwitch(
                                            value: selectValue,  // The current toggle state
                                            onChanged: (val) {
                                              setState(() {
                                                selectValue = val;
                                                optional = selectValue ? "cm" : "inch";
                                                print("Optional value is: $optional");
                                                print("Toggle value is: $selectValue");
                                              });
                                            },
                                            enabledTrackColor: AppColors.primaryRed,  // Custom color for the active state
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            optional,
                                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.all(0),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                                                  child: Column(
                                                    children: [
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.neck, hintText: optional, controller: neckController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number,text: AppLocalizations.of(context)!.bust, hintText: optional, controller: bustController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.underBust, hintText: optional, controller: underBustController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.waist, hintText: optional, controller: waistController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.hips, hintText: optional, controller: hipsController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.neckAbove, hintText: optional, controller: neckToAboveKneeController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.armLength, hintText: optional, controller: armLengthController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.shoulderSeam, hintText: optional, controller: shoulderSeamController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.armHole, hintText: optional, controller: armHoleController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.bicep, hintText: optional, controller: bicepController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.foreArm, hintText: optional, controller: foreArmController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.wrist, hintText: optional, controller: wristController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.shoulderWaist, hintText: optional, controller: shoulderToWaistController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.bottomLength, hintText: optional, controller: bottomLengthController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.ankle, hintText: optional, controller: ankleController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.stitchingCost, hintText: "₹", controller: stitchingCostController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.advancedCost, hintText: "₹", controller: advancedReceivedController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.outstandingBalance, hintText: "₹", controller: outStandingBalanceController,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.notes,
                                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),),
                                      SizedBox(height: 5,),
                                      TextField(controller: textarea,
                                        keyboardType: TextInputType.multiline, maxLines: 4, maxLength: 500,
                                        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.textHere, enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.0, color: Colors.grey))),
                                      ),
                                    ]
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    isPressed = true;
                                  });},
                                onTapUp: (_) async {},
                                onTapCancel: () {
                                  setState(() {
                                    isPressed = false;
                                  });},
                                onTap: () {
                                  if (nameController.text.isEmpty ||
                                      mobileNoController.text.isEmpty ||
                                      dressNameController.text.isEmpty ||
                                      dueDateController.text.isEmpty ||
                                      stitchingCostController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: stitchingCostController.text.isEmpty
                                          ? AppLocalizations.of(context)!.add_warning_message1
                                          : AppLocalizations.of(context)!.add_warning_message,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    // Proceed with saving
                                    addCustomerMethod();
                                  }

                                },
                                child: Container(
                                  width: 350,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isPressed ? AppColors.Gradient1 : [Colors.white, Colors.white],),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: AppColors.primaryRed, width: 2),),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(AppLocalizations.of(context)!.saveDetails1, style: TextStyle(color: isPressed ? Colors.white : AppColors.primaryRed,
                                          fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 19,),),
                                      ],
                                    ),
                                  ),
                                ),
                              ), //buildSaveButton(context),
                            ),
                          ]
                      )
                  )
              )
          )
      ),
    );
  }
  void _pickedImages(BuildContext context) async {
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
              title: Text('Camera'),
              onTap: () async {
                final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  final CroppedFile? croppedFile = await ImageCropper().cropImage(
                    sourcePath: photo.path,
                    uiSettings: _buildUiSettings(),
                  );
                  if (croppedFile != null) {
                    setState(() {
                      _selectedImage = File(croppedFile.path);
                    });
                  }
                }
                Navigator.pop(context); // Close the modal after action
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.black),
              title: Text('Gallery'),
              onTap: () async {
                final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                if (photo != null) {
                  final CroppedFile? croppedFile = await ImageCropper().cropImage(
                    sourcePath: photo.path,
                    uiSettings: _buildUiSettings(),
                  );
                  if (croppedFile != null) {
                    setState(() {
                      _selectedImage = File(croppedFile.path);
                    });
                  }
                }
                Navigator.pop(context); // Close the modal after action
              },
            ),
          ],
        );
      },
    );
  }
  List<PlatformUiSettings> _buildUiSettings() {
    return [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.ratio3x2,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Cropper',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
        ],
      ),
    ];
  }

  Future<void> addCustomerMethod() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken')!;
    print("Access Token is $accessToken");
    Uri url = Uri.parse('$apiImageBaseUrl/order/addCustomerOrder');
    print("Url is $url");
    var request = http.MultipartRequest('POST', url);
    request.headers['accept'] = "application/json";
    request.headers['Authorization'] = "Bearer $accessToken";
    request.fields["name"] = nameController.text.toString();
    request.fields["dueDate"] = formattedDate;
    request.fields["mobileNo"] = mobileNoController.text.toString();
    request.fields["neck"] = neckController.text.toString();
    request.fields["Bust"] = bustController.text.toString();
    request.fields["underBust"] = underBustController.text.toString();
    request.fields["waist"] = waistController.text.toString();
    request.fields["hips"] = hipsController.text.toString();
    request.fields["neckToAboveKnee"] =
        neckToAboveKneeController.text.toString();
    request.fields["armLength"] = armLengthController.text.toString();
    request.fields["shoulderSeam"] = shoulderSeamController.text.toString();
    request.fields["armHole"] = armHoleController.text.toString();
    request.fields["bicep"] = bicepController.text.toString();
    request.fields["foreArm"] = foreArmController.text.toString();
    request.fields["wrist"] = wristController.text.toString();
    request.fields["shoulderToWaist"] =
        shoulderToWaistController.text.toString();
    request.fields["bottomLength"] = bottomLengthController.text.toString();
    request.fields["ankle"] = ankleController.text.toString();
    request.fields["stitchingCost"] = stitchingCostController.text.toString();
    request.fields["advanceReceived"] =
    advancedReceivedController.text.isEmpty ? "00" : advancedReceivedController.text.toString();
    request.fields["outstandingBalance"] =
        outStandingBalanceController.text.toString();
    request.fields["notes"] = textarea.text.toString();
    request.fields["dressName"] = dressNameController.text.toString();
    request.fields["measurementUnit"] = optional.toString();

    var image = await http.MultipartFile.fromPath(
      'dressImgUrl',
      _selectedImage!.absolute.path,
    );
    request.files.add(image);
    request.headers['Content-Type'] = 'multipart/form-data';
    print("Add Customer requestttttttt");
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
      print("Message is : ${jsonbody['message']}");
      Fluttertoast.showToast(
          msg: jsonbody['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      fileName = "";
      formattedDate = "";
      nameController.clear();
      mobileNoController.clear();
      neckController.clear();
      bustController.clear();
      underBustController.clear();
      waistController.clear();
      hipsController.clear();
      neckToAboveKneeController.clear();
      armLengthController.clear();
      shoulderSeamController.clear();
      armHoleController.clear();
      bicepController.clear();
      foreArmController.clear();
      wristController.clear();
      shoulderToWaistController.clear();
      bottomLengthController.clear();
      ankleController.clear();
      stitchingCostController.clear();
      advancedReceivedController.clear();
      outStandingBalanceController.clear();
      textarea.clear();
      dressNameController.clear();
      dueDateController.clear();
      optional = "";
      _selectedImage = null;
      updateUI();
    }
  }
  void updateUI() {
    setState(() {});
  }
  _checkInput(String input) {
    if (input.length == 10) {
      _callVerifyMobile(input);
      // Optionally unfocus the TextField after 10 digits
      _focusNode.unfocus();
    } else if (input.length < 10) {
      setState(() {
        message = ""; // Hide the "Number is already registered" box
      });
    }
  }

  _callVerifyMobile(String input) {
    setState(() {
      isLoading = true;
      var map = Map<String, dynamic>();
      map['mobileNo'] = input.toString();
      print("Map value is $map");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Mobile_Verify_Model model =
        await CallService().verifyCustomerMobile(map);
        setState(() {
          isLoading = false;
          message = model.message.toString();
          print("Message received: $message");
        });
      });
    });
  }

  void showWarningMessage(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) {
    showDialog(
      context: context,
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
                      onPressed: () async {
                        final result = await
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TailorDashboardNew(locale: widget.locale,)),
                        );
                        Navigator.pop(context, true);

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

