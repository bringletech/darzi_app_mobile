import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/apiData/model/customer_delete_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/customer/common_text_Field/commont_text_field.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_search_customer_without_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_new_dress.dart';
import 'dresses.dart';
import 'measurments.dart';

class SearchPage extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  final Locale locale;
  SearchPage({super.key, required this.locale});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Customers> filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();
  List<Customers> customersList = [];
  bool isLoading = false;
  bool isRefreshing = false;
  String customerId = "";

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _loadData() async {
    if (!isRefreshing) {
      // Show loading indicator only for initial load, not during refresh
      setState(() {
        isLoading = true;
      });
    }
    try {
      Current_Tailor_Response model = await CallService().getCurrentTailorDetails();
      setState(() {
        customersList = model.data?.customers ?? [];
        filteredContacts = customersList;
      });
    } finally {
      setState(() {
        isLoading = false;
        isRefreshing = false; // Reset refresh state
      });
    }
  }
  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = customersList.where((contact) {
        return contact.name!.toLowerCase().contains(query) ||
            contact.mobileNo!.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _deleteCustomerData(String customerId) async {
    var map =  Map<String, dynamic>();
    map['customerId'] = customerId;
    print("Map is $map");
    setState(() {
      isLoading = true;
    });

    try {
      CustomerDeleteResponseModel model = await CallService().removeCustomerFromList(map);
      String deleteMessage = model.message.toString();
      print("Delete Response: $deleteMessage");

      // Refresh the list after deletion
      await _loadData();
    } catch (error) {
      print("Error deleting customer: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

      child: Scaffold(
        appBar: CustomAppBarSearchCustomerWithOutBack(
          title: AppLocalizations.of(context)!.searchCustomer,
          hasBackButton: true,
          elevation: 2.0,
          leadingIcon: SvgPicture.asset(
            'assets/svgIcon/searchCustomer.svg',
            color: Colors.black,
          ),
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              isRefreshing = true; // Show RefreshIndicator
            });
            await _loadData();
          },
          child: Column(
            children: [
              const SizedBox(height: 5),
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.mobileOrName,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: isLoading && !isRefreshing
                    ? Center(
                  child: CircularProgressIndicator(color: AppColors.darkRed),
                )
                    : filteredContacts.isEmpty
                    ? Center(
                  child: Text(
                    "No customers found.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    customerId = contact.id.toString();
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(120.0),
                            ),
                            elevation: 8,
                            child: ListTile(
                              minTileHeight: 30,
                              title: Text(
                                contact.name.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                contact.mobileNo.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  customerId = contact.id.toString();
                                  showSearchBottomSheet(context, customerId);
                                },
                                child: const Icon(Icons.more_vert),
                              ),
                            ),
                          ),
                        ],
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

  void showSearchBottomSheet(BuildContext context1, String customerId) {
    showModalBottomSheet(
      context: context1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Draggable handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // List of options
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/circleMeasure.svg'),
            title: Text(AppLocalizations.of(context)!.measurements,style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,fontSize: 17,color: Colors.black),),
              onTap: () {
                Navigator.pop(context1);
                Navigator.push(context1,  MaterialPageRoute(builder: (context1) => MeasurementsScreen(context1,customerId,widget.locale)));

              },
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/dresses.svg'),
              title: Text(AppLocalizations.of(context)!.dresses,style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,fontSize: 17,color: Colors.black)),
              onTap: () {
                Navigator.pop(context1);
                Navigator.push(context1,  MaterialPageRoute(builder: (context1) => oldDress(customerId,context1,widget.locale)));
              },
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/add.svg'),
              title: Text(AppLocalizations.of(context)!.addNewDress,style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,fontSize: 17,color: Colors.black)),
              onTap: () {
                Navigator.pop(context1);
                Navigator.push(context1,  MaterialPageRoute(builder: (context) =>AddNewDress(context1,customerId,widget.locale)));
              },
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/remove_icon.svg'),
              title: Text(AppLocalizations.of(context)!.remove_customer,style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,fontSize: 17,color: Colors.black)),
              onTap: () {
                Navigator.pop(context1);
                showRemoveCustomerDialog(context1,customerId,widget.locale);
                //Navigator.push(context1,  MaterialPageRoute(builder: (context) =>AddNewDress(context1,customerId,widget.locale)));
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }
  void showRemoveCustomerDialog(BuildContext context, String customerId, Locale locale) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.confirm_remove_customer,
            style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 20),
          ),
          content: Text(
            AppLocalizations.of(context)!.confirm_remove_customer_message,
            style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Inter', fontSize: 16, color: Colors.grey),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.red,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        await _deleteCustomerData(customerId); // Delete customer and refresh list
                      },
                      child: Text(
                        AppLocalizations.of(context)!.yesMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

}


