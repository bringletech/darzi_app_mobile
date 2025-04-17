import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/pages/tailor/screens/tailor_active_dress/view/tailor_full_active_dress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActiveDress extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );
  final Locale locale;
  ActiveDress({super.key, required this.locale,});

  @override
  State<ActiveDress> createState() => _ActiveDressState();
}

class _ActiveDressState extends State<ActiveDress> {
  bool isLoading = false;
  List<SpecificCustomerOrder> orderActiveList = [];
  // List<Customers> customersList = [];

  @override
  void initState() {
    super.initState();
    //_loadData(); // Call the async method
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Current_Tailor_Response model =
        await CallService().getCurrentTailorDetails();
        setState(() {
          isLoading = false;
          orderActiveList = model.data!.order!;
          // customersList = model.data!.customers!;
          print("list Value is: $orderActiveList");
          // print("list Value is: ${customersList.length}");
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
          MaterialPageRoute(builder: (context) => TailorDashboardNew(locale: widget.locale,)),
        );
        return false; // Prevent default back behavior
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,),
        child: Scaffold(
          appBar: CustomAppBarWithBack(
            title: AppLocalizations.of(context)!.activeDresses,
            hasBackButton: true,
            elevation: 2.0,
            leadingIcon: SvgPicture.asset(
              'assets/svgIcon/dress.svg',//just change my image with your image
              color: Colors.black,
            ),
              onBackButtonPressed: () async {
                final result = await
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TailorDashboardNew(locale: widget.locale,)),
                ); Navigator.pop(context, true);
              }
          ),
          body: isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.darkRed,)):Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                      AppLocalizations.of(context)!.recentData,
                        style: TextStyle(fontSize: 19,fontFamily: 'Poppins', fontWeight: FontWeight.w400),
                      ),
                      // IconButton(
                      //   icon: SvgPicture.asset(
                      //     'assets/svgIcon/recent.svg',//just change my image with your image
                      //     color: Colors.black,
                      //   ),
                      //   onPressed: () {
                      //     // Implement filter functionality
                      //   },
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderActiveList.length, // Replace with actual count of items
                    itemBuilder: (context, index) {
                      final contact = orderActiveList[index];
                      DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(contact.dueDate.toString());
                      String dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
                      print("Final Date is : $dateTime");
                      String URL = contact.dressImgUrl.toString();
                      print("imageurl is $URL");
                      // Corrected this line
                      return GestureDetector(
                        onTap: (){
                          //Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TailorFullActiveDress(contact,locale: widget.locale)),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 9,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                height: 50,
                                width: 50,
                                imageUrl: URL,
                                //imageUrl: 'https://w7.pngwing.com/pngs/827/140/png-transparent-t-shirt-fashion-clothing-mens-fashion-tshirt-abdomen-formal-wear.png',
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress,color:AppColors.darkRed),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                            title: Text(contact.name!=null?contact.name.toString():"No Name",style: TextStyle(fontFamily: "Poppins",fontSize: 19,fontWeight: FontWeight.w500),), // Change to dynamic name
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.dueDate}:  $dateTime",
                                  //"Due Date :  ${dateTime.toString()}",
                                  style: TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  contact.status == "Stitching"
                                      ? "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressProgress}"
                                      : "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressComplete}",
                                  style: TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w400, color:
                                  contact.status == "Stitching" ?Colors.green:AppColors.primaryRed),
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text("${AppLocalizations.of(context)!.cost}"
                                  ,style: TextStyle(fontFamily: "Poppins",fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text('₹${contact.stitchingCost.toString()}',style: TextStyle(fontFamily: "Poppins",fontSize: 14,fontWeight: FontWeight.w400),),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}