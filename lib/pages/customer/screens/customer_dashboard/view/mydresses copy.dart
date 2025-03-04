// import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
// import 'package:darzi/constants/string_constant.dart';
// import 'package:darzi/pages/customer/screens/customer_dashboard/view/mydressesfullview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class MyDresses extends StatefulWidget {
//   final Locale locale;
//   MyDresses({super.key, required this.locale});
//
//
//   @override
//   State<MyDresses> createState() => _MyDressesState();
// }
//
// class _MyDressesState extends State<MyDresses> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: CustomAppBarWithBack(
//         title: AppLocalizations.of(context)!.myDresses,
//         hasBackButton: true,
//         elevation: 2.0,
//         leadingIcon: SvgPicture.asset(
//           'assets/svgIcon/dress.svg',//just change my image with your image
//           color: Colors.black,
//         ),
//         onBackButtonPressed: (){
//           Navigator.pop(context);
//         },
//       ),
//       body: Container(
//         padding: const EdgeInsets.only(top: 20),
//         color: Colors.white,
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 4, // Replace with actual count of items
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => CustomerFullActiveDress(locale: widget.locale)),
//                       );
//                     },
//                     child: Card(
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50.0),
//                       ),
//                       elevation: 9,
//                       child: ListTile(
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: Image.asset('assets/images/dresssample.png', // Replace with actual image URLs
//                             fit: BoxFit.cover,
//                             height: 50,
//                             width: 50,
//                           ),
//                         ),
//                         title: Text(AppLocalizations.of(context)!.dressName,style: TextStyle(fontFamily: "Poppins",fontSize: 19,fontWeight: FontWeight.w500),), // Change to dynamic name
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${AppLocalizations.of(context)!.dueDate}: 12/12/2024',
//                               style: TextStyle(
//                                 fontFamily: "Poppins",
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             Text(
//                               '${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressProgress}', // Replace with dynamic status if needed
//                               style: TextStyle(
//                                 fontFamily: "Poppins",
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.green, // Customize color to indicate different statuses
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: Column(
//                           children: [
//                             Text(AppLocalizations.of(context)!.cost,style: TextStyle(fontFamily: "Poppins",fontSize: 19,fontWeight: FontWeight.w500,color: Colors.black),),
//                             Text('₹1000',style: TextStyle(fontFamily: "Poppins",fontSize: 14,fontWeight: FontWeight.w400),),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../colors.dart';
import 'mydressesfullview.dart';

class MyDresses extends StatefulWidget {
  final Locale locale;
 MyDresses({super.key, required this.locale});

  @override
  State<MyDresses> createState() => _MyDressesState();
}

class _MyDressesState extends State<MyDresses> {
  List<CustomerOrder> orderList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch orders when the screen loads
  }

  Future<void> _fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Call the API to get orders list
      Get_Current_Customer_Response_Model model = await CallService().getMyTailorList_order();
      setState(() {
        orderList = model.data?.order ?? []; // Safely assign the order list
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching orders: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithBack(
        title: StringConstant.myDresses,
        hasBackButton: true,
        elevation: 2.0,
        leadingIcon: SvgPicture.asset(
          'assets/svgIcon/dress.svg', // Replace with actual SVG asset
          color: Colors.black,
        ),
        color: Colors.white,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Show loader while fetching
      )
          : orderList.isEmpty
          ? const Center(
        child: Text(
          'No dresses found',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        ),
      )
          : Container(
        padding: const EdgeInsets.only(top: 20),
        color: Colors.white,
        child: ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            final order = orderList[index];
            String dressId = order.id.toString();
            print('Specific Dress Id is $dressId');
            DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(order.dueDate.toString());
            String dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerFullActiveDress(
                                    dressId,locale: widget.locale)),
                          );
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
                              child:
                                  // Image.asset('assets/images/dresssample.png', // Replace with actual image URL
                                  CachedNetworkImage(
                                // Replace with actual image URL
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                                imageUrl: order.dressImgUrl.toString(),
                              ),
                            ),
                            title: Text(
                              order.dressName ??
                                  'Dress Name', // Dynamic dress name
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.dueDate}:  $dateTime",
                                  //"Due Date :  ${dateTime.toString()}",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  order.status == "Stitching"
                                      ? "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressProgress}"
                                      : "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressComplete}",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: order.status == "Stitching"
                                          ? Colors.green
                                          : AppColors.primaryRed),
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Cost',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                Text(
                                  '₹${order.stitchingCost ?? "0.00"}', // Dynamic cost
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
        ),
      ),
    );
  }
}
