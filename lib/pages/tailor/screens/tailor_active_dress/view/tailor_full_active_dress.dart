import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/apiData/model/order_status_change_model.dart';
import 'package:darzi/apiData/model/static_model_class/specific_order_detail_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/customer/common_app_bar_search_customer_without_back.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/pages/tailor/screens/tailor_active_dress/view/active_dress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../../../apiData/call_api_service/call_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TailorFullActiveDress extends StatefulWidget {
  SpecificCustomerOrder contact;
  final Locale locale;
  TailorFullActiveDress(this.contact, {super.key,required this.locale});
  // List<SpecificCustomerOrder> contact = [];


  @override
  State<TailorFullActiveDress> createState() => _TailorFullActiveDressState();
}

class _TailorFullActiveDressState extends State<TailorFullActiveDress> {
  bool _isRefreshed = false;
  bool isLoading = false;
  String customerId = "", dueDate = "",dateTime = "";
  SpecificData? specificData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUpdateData();
  }
 loadUpdateData(){
   setState(() {
     isLoading = true;
     String dressId = widget.contact.id.toString();
     print("customer Id is : $dressId");
     WidgetsBinding.instance.addPostFrameCallback((_) async {
       Specific_Order_Detail_Response_Model model =
       await CallService().getSpecificDreesDetails(dressId);
       setState(() {
         isLoading = false;
         specificData = model.data;
         // name = model.data!.name.toString();
         // dressName = model.data!.dressName.toString();
         // dressImageUrl = model.data!.dressImgUrl.toString();
         // cost = model.data!.stitchingCost.toString();
         // advanceCost = model.data!.advanceReceived.toString();
         // remainBalance = model.data!.outstandingBalance.toString();
         dueDate = model.data!.dueDate.toString();
         //status = model.data!.status.toString();
         DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(dueDate.toString());
         dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
         // print("list Value is: ${customersList.length}");
       });
     });
   });
 }

  @override
  Widget build(BuildContext context) {
    String dressId = widget.contact.id.toString();
    print("Dress Id is : $dressId");
    print("Final Date is : $dateTime");
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ActiveDress(locale: widget.locale,)),
        );
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBarWithBack(
          title: AppLocalizations.of(context)!.dressDetails,
          hasBackButton: true,
          onBackButtonPressed: () async{
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveDress(locale: widget.locale,)),);
            Navigator.pop(context, true);
           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ActiveDress(locale: widget.locale,)));
          },
          elevation: 2.0,
          leadingIcon: SvgPicture.asset(
            'assets/svgIcon/activeDress.svg',
            color: Colors.black,
          ),
        ),
        body: isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.darkRed,)):Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
                child: CachedNetworkImage(
                  imageUrl: specificData!.dressImgUrl.toString(),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 4.0,
                      blurRadius: 4.0,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.userName} :",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              specificData!.name??AppLocalizations.of(context)!.noUserName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
      
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            "${AppLocalizations.of(context)!.dressName} :",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              specificData!.dressName??AppLocalizations.of(context)!.noDressName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.cost} :",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "₹${specificData!.stitchingCost.toString()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.advancedCost} :",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "₹${specificData!.advanceReceived.toString()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.remainingBalance} :",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "₹${specificData!.outstandingBalance.toString()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.dueDate} :",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              dateTime.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
      
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.dressStatus} :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: specificData!.status.toString() == "Stitching"?Colors.green:AppColors.primaryRed,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              specificData!.status.toString() == "Stitching"?
                              "${specificData!.status..toString()}":"${AppLocalizations.of(context)!.dressComplete}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: specificData!.status.toString() == "Stitching"?Colors.green:AppColors.primaryRed,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: specificData!.status.toString() ==
                            "Completed"
                            ? Colors.grey
                            : Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: specificData!.status.toString() ==
                          "Completed"
                          ? null
                          : () {
                        String complete = "Completed";
                        _callVerifyMobile(complete);
                        // final result =
                        // Navigator.push(context, MaterialPageRoute(
                        //     builder: (context) => ActiveDress()));
                        // if (result == true) {
                        //   setState(() {
                        //     _isRefreshed = true;
                        //   });
                        // }
                      },
                            child: Text(
                              AppLocalizations.of(context)!.dressIsComplete,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white),
                            )
                          )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

  }

  _callVerifyMobile(String input) {
    setState(() {
      isLoading = true;
      customerId = widget.contact.id.toString();
      var map = Map<String, dynamic>();
      map['id'] = customerId;
      map['status'] = input.toString();
      print("Map value is $map");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Order_Status_Change_Model model = await CallService().updateDreesOrderStatus(map);
        setState(() {
          isLoading = false;
          String message = model.message.toString();
          // customersList = model.data!.customers!;
          print("list Value is: $message");
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          loadUpdateData();
          // print("list Value is: ${customersList.length}");
        });
      });
    });
  }
}