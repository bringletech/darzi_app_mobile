// import 'package:darzi/apiData/model/static_model_class/contacts.dart';
// import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
// import 'package:darzi/constants/string_constant.dart';
// import 'package:darzi/pages/customer/screens/customer_dashboard/view/tailor_details.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class MyTailors extends StatefulWidget {
//   final Locale locale;
//   MyTailors({super.key, required this.locale});
//
//
//   @override
//   State<MyTailors> createState() => _MyTailorsState();
// }
//
// class _MyTailorsState extends State<MyTailors> {
//   List<Contact> filteredContacts = [];
//
//   // TextEditingController for the search input
//   final TextEditingController _searchController = TextEditingController();
//
//   final List<Contact> contacts = [
//     Contact(name: "Roshan", phoneNumber: "9876421360"),
//     Contact(name: "Ritesh", phoneNumber: "9876564567"),
//     Contact(name: "Vijay", phoneNumber: "7889098765"),
//     Contact(name: "Soumya", phoneNumber: "9876543210"),
//     Contact(name: "Ankit", phoneNumber: "6767812345"),
//     Contact(name: "Rishika", phoneNumber: "9876421361"),
//     Contact(name: "Lakshmi", phoneNumber: "9876564568"),
//     Contact(name: "Kamal", phoneNumber: "7889098790"),
//     Contact(name: "Sunny", phoneNumber: "9876543210"),
//     Contact(name: "Amit", phoneNumber: "8765432120"),
//     Contact(name: "Darshnik", phoneNumber: "9529019408"),
//     Contact(name: "Anshu", phoneNumber: "9876564588"),
//     Contact(name: "Ravindra", phoneNumber: "7889098880"),
//     Contact(name: "Sonia", phoneNumber: "9876543321"),
//     Contact(name: "Kanchan", phoneNumber: "8123456789"),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     filteredContacts = contacts; // Initially show all contacts
//
//     // Listen to the text changes in the search field
//     _searchController.addListener(_filterContacts);
//   }
//
//   // Filter contacts based on the search query
//   void _filterContacts() {
//     String query = _searchController.text.toLowerCase();
//
//     setState(() {
//       filteredContacts = contacts.where((contact) {
//         // Search by name or phone number
//         return contact.name.toLowerCase().contains(query) ||
//             contact.phoneNumber.contains(query);
//       }).toList();
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: CustomAppBarWithBack(
//           title: AppLocalizations.of(context)!.myTailor,
//           hasBackButton: true,
//           elevation: 2.0,
//           leadingIcon: SvgPicture.asset(
//             'assets/svgIcon/myTailor.svg', //just change my image with your image
//             color: Colors.black,
//           ),
//           onBackButtonPressed: (){
//             Navigator.pop(context);
//           },
//         ),
//         body: Container(
//           padding: const EdgeInsets.only(top: 8.0),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: filteredContacts.length,
//                   itemBuilder: (context, index) {
//                     final contact =
//                       filteredContacts[index]; // Corrected this line
//                   return ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: (){
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => TailorDetails(locale:widget.locale)),
//                             );
//                           },
//
//                           child: Card(
//                             color: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(120.0),
//                             ),
//                             elevation: 8,
//                             child: ListTile(
//                                 leading: ClipRRect(
//                                   borderRadius: BorderRadius.circular(40.0), // Circular shape
//                                   child: Image.asset(
//                                     'assets/images/casual.jpg', // Replace with actual image path
//                                     height: 50, // Set appropriate height
//                                     width: 50,  // Set appropriate width
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 minTileHeight: 30,
//                                 title: Text(
//                                   contact.name,
//                                   style: TextStyle(
//                                       color: Color(0xFF000000),
//                                       fontSize: 17,
//                                       fontFamily: 'Poppins',
//                                       fontWeight:
//                                       FontWeight.w500), // Title color
//                                 ),
//                                 subtitle: Text(
//                                   contact.phoneNumber.toString(),
//                                   style: TextStyle(
//                                       color: Color(0xFF000000),
//                                       fontSize: 12,
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.w300),
//                                 ) // Subtitle color
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                                 ),
//           ),
//
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTailors extends StatefulWidget {
  final Locale locale;
   MyTailors({super.key, required this.locale});

  @override
  State<MyTailors> createState() => _MyTailorsState();
}

class _MyTailorsState extends State<MyTailors> {
  List<Tailors> tailorList = []; // List to store API response
  List<Tailors> filteredTailors = []; // Filtered list for search
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true; // To show loading indicator

  @override
  void initState() {
    super.initState();
    fetchTailorList();
    _searchController.addListener(_filterTailors);
  }

  // Call the API to fetch the tailor list
  Future<void> fetchTailorList() async {
    setState(() {
      isLoading = true;
    });
    try {
      Get_Current_Customer_Response_Model model =
      await CallService().getMyTailorList_order();
      setState(() {
        tailorList = model.data?.tailors ?? [];
        filteredTailors = tailorList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tailors: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Filter tailors based on search input
  void _filterTailors() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredTailors = tailorList.where((tailor) {
        return tailor.name!.toString().toLowerCase().contains(query) ||
            tailor.mobileNo!.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWithBack(
          title: AppLocalizations.of(context)!.myTailor,
          hasBackButton: true,
          elevation: 2.0,
          leadingIcon: SvgPicture.asset(
            'assets/svgIcon/myTailor.svg', //just change my image with your image
            color: Colors.black,
          ),
          onBackButtonPressed: (){
            Navigator.pop(context);
          },
        ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Loading indicator
      )
          : Column(
        children: [
          Expanded(
            child: filteredTailors.isEmpty
                ? const Center(
              child: Text(
                "No tailors found.",
                style: TextStyle(fontSize: 16),
              ),
            )
                : Container(
              padding: const EdgeInsets.only(top: 20),
              color: Colors.white,
                  child: ListView.builder(
                                itemCount: filteredTailors.length,
                                itemBuilder: (context, index) {
                  final tailor = filteredTailors[index];
                  print("specific tailor id is ${tailor.id}");
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    elevation: 4,
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
                          imageUrl: tailor.profileUrl.toString(),
                        ),
                      ),
                      title: Text(
                        tailor.name ?? '',
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        tailor.mobileNo ?? '',
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onTap: () => _showFullScreenImage(tailor),
                    ),
                  );
                                },
                              ),
                ),
          ),
        ],
      ),
    );
  }


  void _showFullScreenImage(Tailors tailorId) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: FullScreenImage(tailors: tailorId),
            ),
          );
        },
      ),
    );
  }
  // Widget _showFullScreenImage(Tailors tailor) {
  //   return Navigator.push(
  //     context,
  //     PageRouteBuilder(
  //       transitionDuration: const Duration(milliseconds: 700),
  //       pageBuilder: (context, animation, secondaryAnimation) {
  //         return FadeTransition(
  //           opacity: animation,
  //           child: ScaleTransition(
  //             scale: Tween<double>(
  //               begin: 0.8,
  //               end: 1.0,
  //             ).animate(CurvedAnimation(
  //               parent: animation,
  //               curve: Curves.easeInOut,
  //             )),
  //             child: FullScreenImage(tailor: tailor),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }



}

class FullScreenImage extends StatelessWidget {
  final Tailors tailors;

  const FullScreenImage({super.key, required this.tailors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithBack(
        title: AppLocalizations.of(context)!.tailorDetail,
        hasBackButton: true,
        elevation: 2.0,
        onBackButtonPressed: (){
          Navigator.pop(context);
        },
        leadingIcon: SvgPicture.asset(
          'assets/svgIcon/myTailor.svg',
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
              child: CachedNetworkImage(
                imageUrl: tailors.profileUrl.toString(),
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
              height: MediaQuery.of(context).size.height * 0.22,
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
                      Text("${AppLocalizations.of(context)!.userName} : ${tailors.name?? AppLocalizations.of(context)!.noUserName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${AppLocalizations.of(context)!.mobileNumber} : ${tailors.mobileNo?? AppLocalizations.of(context)!.noMobileNumber}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "${AppLocalizations.of(context)!.userAddress} : ${tailors.address?? AppLocalizations.of(context)!.userNoAddress}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}