import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/pages/tailor/screens/tailor_active_dress/view/active_dress.dart';
import 'package:darzi/pages/tailor/screens/tailor_add_customer/view/add_customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DarziHomeScreen extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );

  final PageController tabController = PageController(initialPage: 0);
  var selectedIndex = 0;
  final Locale locale;
  DarziHomeScreen({super.key, required this.locale,});

  @override
  State<DarziHomeScreen> createState() => _DarziHomeScreenState();
}

class _DarziHomeScreenState extends State<DarziHomeScreen> {

  final CallService callService = CallService();
  bool isLoading = false;
  List<SpecificCustomerOrder> orderList = [];
  List<Customers> customersList = [];

  // Track if the buttons are tapped
  final List<bool> _isTapped = [false, false];
  int _selectedIndex = 0;
  final int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData(); // Call the async method
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Current_Tailor_Response model =
        await CallService().getCurrentTailorDetails();
        setState(() {
          isLoading = false;
          orderList = model.data!.order!;
          customersList = model.data!.customers!;
          print("list Value is: $orderList");
          print("list Value is: ${customersList.length}");
        });
      });
    });
  }
  void _loadData(){
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Current_Tailor_Response model =
        await CallService().getCurrentTailorDetails();
        setState(() {
          isLoading = false;
          orderList = model.data!.order!;
          customersList = model.data!.customers!;
          print("list Value is: $orderList");
          print("list Value is: ${customersList.length}");
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
        body: isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.darkRed,)):Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              SizedBox(
                height: 135,
                child: customersList.isNotEmpty?GridView.count(
                  crossAxisCount:
                  MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  // Adjust grid count based on screen width
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.4,
                  children: [
                    _buildCustomGridItem(
                        AppLocalizations.of(context)!.addCustomer,
                        SvgPicture.asset(
                      'assets/svgIcon/addCustomer.svg',//just change my image with your image
                      color: Colors.black,
                    ), 0),
                    _buildCustomGridItem1(
                      AppLocalizations.of(context)!.activeDresses, SvgPicture.asset(
                      'assets/svgIcon/dress.svg',//just change my image with your image
                      color: Colors.black,
                    ), 1),
                    // Using dress icon here
                  ],
                ):
                Center(
                  child: GridView.count(
                    crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    // Adjust grid count based on screen width
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.4,
                    children: [
                      _buildCustomGridItem(
                      AppLocalizations.of(context)!.addCustomer,  SvgPicture.asset(
                        'assets/svgIcon/addCustomer.svg',//just change my image with your image
                        color: Colors.black,
                      ), 0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalCustomers(customersList.length),
                    //"Total Customers: ${customersList.length}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  //const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.totalOrders(orderList.length),
                   // "Total Orders: ${orderList.length}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  )
                ],
              )
            ],
          ),
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
        Future.delayed(const Duration(milliseconds: 100), () async {
          setState(() {
            _isTapped[index] = false; // Reset tapped state
          });
          // Navigate to the corresponding page
          if (index == 0) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddCustomer(locale: widget.locale) // tailor page (new route will be added)
              ),
            );
            // Refresh with the result
            if (result == true) {
              setState(() {
                _loadData();
                //data = result;
              });
            }

          } else {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                   ActiveDress(locale: widget.locale) // navigate to active dress page
              ),
            );
            // Refresh with the result
            if (result == true) {
              setState(() {
                _loadData();
                //data = result;
              });
            }
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
                  'assets/svgIcon/addCustomer.svg',//just change my image with your image
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
                      AddCustomer(locale: widget.locale,) // tailor page (new route will be added)
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                   ActiveDress(locale: widget.locale,) // navigate to active dress page
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