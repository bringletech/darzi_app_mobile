// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../../../common/widgets/customer/common_app_bar_search_customer_without_back.dart';
// import '../../../../apiData/model/get_current_customer_list_details_model.dart';
//
// class TailorDetails extends StatelessWidget {
//   final Tailors tailor;
//
//   const TailorDetails({required this.tailor, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarSearchCustomerWithOutBack(
//         title: 'Tailor Details',
//         hasBackButton: true,
//         elevation: 2.0,
//         leadingIcon: SvgPicture.asset(
//           'assets/svgIcon/myTailor.svg',
//           color: Colors.black,
//         ),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 15.0),
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(45),
//                 topRight: Radius.circular(45),
//               ),
//               child: CachedNetworkImage(
//                 imageUrl: tailor.profileUrl ?? "https://picsum.photos/600/800",
//                 fit: BoxFit.cover,
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.22,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(45),
//                   topRight: Radius.circular(45),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.7),
//                     spreadRadius: 4.0,
//                     blurRadius: 4.0,
//                     offset: const Offset(0, -3),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         tailor.name ?? '',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         tailor.mobileNo ?? '',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         tailor.address ?? '',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TailorDetails extends StatefulWidget {
  //final Data contact;
  final Locale locale;
  TailorDetails({super.key, required this.locale});


  @override
  State<TailorDetails> createState() => _TailorDetailsState();
}

class _TailorDetailsState extends State<TailorDetails> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithBack(
        title: AppLocalizations.of(context)!.tailorDetail ,
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
                imageUrl: "https://picsum.photos/600/800",
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
                    // children: [
                    //   Text(
                    //     contact.name.toString(),
                    //     style: const TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 20,
                    //       fontFamily: 'Poppins',
                    //     ),
                    //   ),
                    //   const SizedBox(height: 8),
                    //   Text(
                    //     contact.mobileNo.toString(),
                    //     style: const TextStyle(
                    //       fontSize: 16,
                    //       fontFamily: 'Poppins',
                    //     ),
                    //   ),
                    //   const SizedBox(height: 8),
                    //   Text(
                    //     contact.address.toString(),
                    //     style: const TextStyle(
                    //       fontSize: 16,
                    //       fontFamily: 'Poppins',
                    //     ),
                    //   ),
                    // ],
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