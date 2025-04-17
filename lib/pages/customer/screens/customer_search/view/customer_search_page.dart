import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_search_customer_without_back.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:darzi/apiData/model/get_all_tailors_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CustomerSearchPage extends StatefulWidget {
  final Locale locale;
  CustomerSearchPage({super.key, required this.locale});

  @override
  State<CustomerSearchPage> createState() => _CustomerSearchPageState();
}

class _CustomerSearchPageState extends State<CustomerSearchPage> {
  List<Data> filteredTailorList = [];
  List<Data> tailorList = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get_All_Tailors_response_Model model =
        await CallService().getAllTailorsList();
        setState(() {
          isLoading = false;
          tailorList = model.data!;
          filteredTailorList = tailorList;
          _searchController.addListener(_filterContacts);
        });
      });
    });
  }
  Future<void> _loadData() async {
    setState(() {
      isRefreshing = true;
    });
    Get_All_Tailors_response_Model model = await CallService().getAllTailorsList();
    setState(() {
      isRefreshing = false;
      tailorList = model.data!;
      filteredTailorList = tailorList;
    });
  }
  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredTailorList = tailorList.where((Data data) {
        return data.name.toString().toLowerCase().contains(query) ||
            data.mobileNo.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFullScreenImage(Data contact) {
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
              child: FullScreenImage(contact: contact),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSearchCustomerWithOutBack(
        title: AppLocalizations.of(context)!.searchTailor,
        hasBackButton: true,
        elevation: 2.0,
        leadingIcon: SvgPicture.asset(
          'assets/svgIcon/myTailor.svg',
          color: Colors.black,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Column(
          children: [
            if (isLoading)
              LinearProgressIndicator(
                color: AppColors.darkRed,
                backgroundColor: Colors.white,
              ),
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
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.mobileOrName,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTailorList.length,
                itemBuilder: (context, index) {
                  final contact = filteredTailorList[index];
                  String? userName = contact.name;
                  String url = contact.profileUrl.toString();
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(120),
                    ),
                    elevation: 10,
                    child: ListTile(
                      leading: CachedNetworkImage(
                        height: 50,
                        width: 50,
                        imageUrl: url,
                        imageBuilder: (context, imageProvider) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: AppColors.darkRed,
                            ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                      title: Text(userName ?? AppLocalizations.of(context)!.noUserName),
                      subtitle: Text(contact.mobileNo.toString()),
                      onTap: () => _showFullScreenImage(contact),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FullScreenImage extends StatelessWidget {
  final Data contact;

  const FullScreenImage({required this.contact, super.key});

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
                imageUrl: contact.profileUrl.toString(),
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
                      Text("${AppLocalizations.of(context)!.userName} : ${contact.name?? AppLocalizations.of(context)!.noUserName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                       "${AppLocalizations.of(context)!.mobileNumber} : ${contact.mobileNo?? AppLocalizations.of(context)!.noMobileNumber}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "${AppLocalizations.of(context)!.userAddress} : ${contact.address?? AppLocalizations.of(context)!.userNoAddress}",
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
