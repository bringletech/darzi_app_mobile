
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/specific_customer_dress_detail_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerFullActiveDress extends StatefulWidget {
  //SpecificCustomerOrder contact;
  // List<SpecificCustomerOrder> contact = [];
  final String dressId;
  final Locale locale;
  CustomerFullActiveDress(this.dressId, {super.key,required this.locale});

  @override
  State<CustomerFullActiveDress> createState() => _CustomerFullActiveDressState();
}

class _CustomerFullActiveDressState extends State<CustomerFullActiveDress> {
  bool _isRefreshed = false;
  bool isLoading = false;
  Specific_Customer_Dress_Detail? specific_customer_dress_detail;
  String customerId = "",name = "",dressName = "",dressImageUrl = "",cost = "",advanceCost = "",
      remainBalance = "",dueDate = "",status = "",dateTime = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUpdateData(widget.dressId);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBarWithBack(
        title: AppLocalizations.of(context)!.dressDetails,
        hasBackButton: true,
        onBackButtonPressed: (){
          Navigator.pop(context);
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
                imageUrl: dressImageUrl,
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
                            name.toString(),
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
                            "${dressName.toString()}",
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
                            "₹${cost.toString()}",
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
                            "₹${advanceCost.toString()}",
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
                            "₹${remainBalance.toString()}",
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
                              color: status.toString() == "Stitching"
                                  ?Colors.green:AppColors.primaryRed,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(width: 5,),
                          Text(
                            status.toString() == "Stitching"?
                            "${status.toString()}":"Completed",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: status.toString() == "Stitching"?Colors.green:AppColors.primaryRed,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

  }

  loadUpdateData(String dressId) {
    setState(() {
      isLoading = true;
      print("customer Id is : $dressId");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Specific_Customer_Dress_Detail_Response_Model model =
        await CallService().getCustomerSpecificDressDetail(dressId);
        setState(() {
          isLoading = false;
          specific_customer_dress_detail = model.data;
          name = model.data!.name.toString();
          dressName = model.data!.dressName.toString();
          dressImageUrl = model.data!.dressImgUrl.toString();
          cost = model.data!.stitchingCost.toString();
          advanceCost = model.data!.advanceReceived.toString();
          remainBalance = model.data!.outstandingBalance.toString();
          dueDate = model.data!.dueDate.toString();
          status = model.data!.status.toString();
          print("Status Value is: ${model.data!.status.toString()}");
          DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(dueDate.toString());
          dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
          // print("list Value is: ${customersList.length}");
        });
      });
    });
  }
}
