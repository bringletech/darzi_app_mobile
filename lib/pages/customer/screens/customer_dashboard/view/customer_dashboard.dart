
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/mydresses%20copy.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/mytailors%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerHomeScreen extends StatefulWidget {
  final Locale locale;
  CustomerHomeScreen({super.key, required this.locale});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<Tailors> tailorList = [];
  List<CustomerOrder> orderList = [];
  final List<bool> _isTapped = [false, false];
  int _selectedIndex = 0;
  final int pageIndex = 0;
  bool isLoading= true;


  void initState() {
    super.initState();
    //filteredContacts = contacts;
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get_Current_Customer_Response_Model model =
        await CallService().getMyTailorList_order();
        setState(() {
          isLoading = false;
          tailorList = model.data!.tailors!;
          orderList = model.data!.order!;
          print("name Value is: ${tailorList.length}");
          print("name Value is: ${orderList.length}");
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double spotlightWidth = screenWidth * 0.9; // Define the width for the Style Spotlight section

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.appHome,
          hasBackButton: true,
          elevation: 2.0,
          leadingIcon: SvgPicture.asset(
            'assets/svgIcon/home.svg',
            allowDrawingOutsideViewBox: true,
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Expanded(
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount:
                MediaQuery.of(context).size.width > 600 ? 3 : 2,
                // Adjust grid count based on screen width
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.4,
                children: [
                  _buildCustomGridItem(
                      AppLocalizations.of(context)!.myTailor,
                     SvgPicture.asset('assets/svgIcon/myTailor.svg',),
                      0),
                  _buildCustomGridItem1(
                      AppLocalizations.of(context)!.myDresses, SvgPicture.asset(
                    'assets/svgIcon/dress.svg',
                    color: AppColors.primaryRed,
                  ), 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCustomGridItem(String label, Widget icon, int index) {
  return GestureDetector(
    onTapDown: (_) {
      setState(() {
        _isTapped[index] = true; // Set tapped state
      });
    },
    onTapUp: (_) {
      // Reset tapped state after a brief delay
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _isTapped[index] = false; // Reset tapped state
        });
        // Navigate to the corresponding page
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyTailors(locale: widget.locale) // tailor page (new route will be added)
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                MyDresses(locale: widget.locale,) // navigate to active dress page
            ),
          );
        }
      });
    },
    onTapCancel: () {
      setState(() {
        _isTapped[index] = false; // Reset tapped state on cancel
      });
    },
    child: Material(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(1.0),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isTapped[index]
                ? AppColors.Gradient1 // Red gradient when pressed
                : [
              Colors.white,
              Colors.white
            ], // White background when not pressed
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: AppColors.borderColor,
              width: 2), // Keep your original border color
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgIcon/myTailor.svg',//just change my image with your image
                color: _isTapped[index] ? Colors.white : AppColors.primaryRed,
                width: 39,
                height: 37,

              ),
              const SizedBox(height: 0),
              Text(
                softWrap: true,
                textAlign: TextAlign.center,
                label,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color:
                  _isTapped[index] ? Colors.white : AppColors.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
Widget _buildCustomGridItem1(String label, Widget icon, int index) {
  return GestureDetector(
    onTapDown: (_) {
      setState(() {
        _isTapped[index] = true; // Set tapped state
      });
    },
    onTapUp: (_) {
      // Reset tapped state after a brief delay
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _isTapped[index] = false; // Reset tapped state
        });
        // Navigate to the corresponding page
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyTailors(locale: widget.locale,) // tailor page (new route will be added)
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                 MyDresses(locale: widget.locale,) // navigate to active dress page
            ),
          );
        }
      });
    },
    onTapCancel: () {
      setState(() {
        _isTapped[index] = false; // Reset tapped state on cancel
      });
    },
    child: Material(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(1.0),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isTapped[index]
                ? AppColors.Gradient1 // Red gradient when pressed
                : [
              Colors.white,
              Colors.white
            ], // White background when not pressed
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: AppColors.borderColor,
              width: 2), // Keep your original border color
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgIcon/dress.svg',//just change my image with your image
                color: _isTapped[index] ? Colors.white : AppColors.primaryRed,
                width: 20,
                height: 40,
              ),
              const SizedBox(height: 0),
              Text(
                textAlign: TextAlign.center,
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color:
                  _isTapped[index] ? Colors.white : AppColors.primaryRed,
                  fontWeight: FontWeight.w600,
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

