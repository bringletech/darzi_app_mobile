import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/apiData/model/specific_customer_dress_details_model.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/pages/tailor/screens/tailor_search/view/specific_customer_dress_fullview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class oldDress extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );
  final String customerId;
  final BuildContext context;
  final Locale locale;
  const oldDress(this.customerId,this.context,this.locale, {super.key});


  @override
  State<oldDress> createState() => _ActiveDressState();
}

class _ActiveDressState extends State<oldDress> {
  bool _isRefreshed = false;
  bool isLoading = false;
  String dressImageUrl = "";
  List<Data> customerDressList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loadData();
    });
  }

  loadData(){
    setState(() {
      isLoading = true;
      String cId = widget.customerId.toString();
      print("customer Id is : $cId");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Specific_Customer_Dress_Details_Model model =
        await CallService().getSpecificCustomerDressDetails(cId);
        setState(() {
          isLoading = false;
          customerDressList = model.data!;
          // print("list Value is: ${customersList.length}");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,),
      child: Scaffold(
        appBar: CustomAppBarWithBack(
          onBackButtonPressed: () async {
            Navigator.pop(widget.context,true);
          },
          title: AppLocalizations.of(context)!.dresses,
          hasBackButton: true,
          elevation: 2.0,
          leadingIcon: SvgPicture.asset(
            'assets/svgIcon/dress.svg',//just change my image with your image
            color: Colors.black,
          ),
        ),
        body: isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.darkRed,),):Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: customerDressList.length, // Replace with actual count of items
                  itemBuilder: (context, index) {
                    final contact = customerDressList[index];
                    DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(contact.dueDate.toString());
                    String dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
                    print("Final Date is : $dateTime");
                    return GestureDetector(
                      onTap: (){
                        String dressId = contact.id.toString();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificCustomerDressFullview(dressId, widget.customerId, widget.locale),
                          ),
                        ).then((shouldRefresh) {
                          if (shouldRefresh == true) {
                            // Call your refresh logic here
                            loadData(); // Replace this with your actual data-loading method
                          }
                        });
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        elevation: 9,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              height: 50,
                              width: 50,
                              //imageUrl: 'https://w7.pngwing.com/pngs/827/140/png-transparent-t-shirt-fashion-clothing-mens-fashion-tshirt-abdomen-formal-wear.png',
                              imageUrl: contact.dressImgUrl.toString(),
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress,color:AppColors.darkRed),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          title: Text(contact.dressName.toString(),style: TextStyle(fontFamily: "Poppins",fontSize: 19,fontWeight: FontWeight.w500),), // Change to dynamic name
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.dueDate} :  ${dateTime.toString()}",
                                style: TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                contact.status == "Stitching" ? "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressProgress}"
                                : "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressComplete}",
                                style: TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w400, color:  contact.status == "Stitching" ?Colors.green:AppColors.primaryRed),
                              ),
                            ],
                          ),                        trailing: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.cost,style: TextStyle(fontFamily: "Poppins",fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
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
    );
  }
}
