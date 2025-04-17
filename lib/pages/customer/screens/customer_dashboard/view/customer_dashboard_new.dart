
import 'package:darzi/colors.dart';
import 'package:darzi/common/common_bottom_navigation.dart';
import 'package:darzi/common/widgets/tab_data.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard.dart';
import 'package:darzi/pages/customer/screens/customer_profile/view/customer_profile_page.dart';
import 'package:darzi/pages/customer/screens/customer_search/view/customer_search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Import the new routes file

class CustomerDashboardNew extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );

  final PageController tabController = PageController(initialPage: 1);

  var selectedIndex = 1;
  final Locale locale;

  CustomerDashboardNew({super.key, required this.locale,});

  @override
  State<CustomerDashboardNew> createState() => _CustomerDashboardNewState();
}

class _CustomerDashboardNewState extends State<CustomerDashboardNew> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
        child: CircleBottomNavigation(
          barHeight: 80,
          circleSize: 65,
          initialSelection: widget.selectedIndex,
          activeIconColor: Colors.red,
          inactiveIconColor: Colors.white,
          barBackgroundColor: AppColors.primaryRed,
          textColor: Colors.red,
          hasElevationShadows: false,
          tabs: [
            TabData(
              onClick: () {

              },
              icon: Icons.search,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            TabData(
              onClick: () {
              },
              icon: Icons.grid_view,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            TabData(
              onClick: () {

              },
              icon: Icons.person,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),

          ],
          onTabChangedListener: (index) {
            setState(() {
              widget.selectedIndex = index;
              widget.tabController.jumpToPage(index);

              print("index..............    $index");
            });
          },
        ),
      ),
      body: PageView(
        controller: widget.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Center(
            child: CustomerSearchPage(locale: widget.locale),
          ),
          Center(
            child: CustomerHomeScreen(locale: widget.locale),
          ),
          Center(
            child: CustomerProfilePage(locale: widget.locale),
          ),
        ],
      ),
    );
  }
}
