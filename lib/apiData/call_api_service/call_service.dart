import 'package:darzi/apiData/all_urls/all_urls.dart';
import 'package:darzi/apiData/model/current_customer_response_model.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/apiData/model/customer_delete_response_model.dart';
import 'package:darzi/apiData/model/customer_otp_verification_model.dart';
import 'package:darzi/apiData/model/get_all_tailors_model.dart';
import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
import 'package:darzi/apiData/model/login_model.dart';
import 'package:darzi/apiData/model/specific_customer_dress_detail_response_model.dart';
import 'package:darzi/apiData/model/specific_customer_dress_details_model.dart';
import 'package:darzi/apiData/model/speicific_customer_mearsure_model.dart';
import 'package:darzi/apiData/model/update_customer_measurement_details_model.dart';
import 'package:darzi/apiData/model/update_customer_profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/order_status_change_model.dart';
import '../model/otp_verification_model.dart';
import '../model/static_model_class/specific_order_detail_response_model.dart';
import '../model/verify_mobile_model.dart';

class CallService extends GetConnect{

  // Tailor
  //1). For Getting Otp(For Tailor)
  Future<LoginResponseModel> userLogin(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
      var res = await post('tailor/login', body, headers: {
        'accept': 'application/json',
        /*'Authorization': "Bearer $accessToken",*/
      });
      print("response is ${res.statusCode}");
      if (res.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Login Response is : ${res.statusCode.toString()}");
        return LoginResponseModel.fromJson(res.body);
      } else {
        throw Fluttertoast.showToast(
            msg: res.body["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }

  //2). For Verifying Otp
  Future<OtpVerificationResponseModel> tailorOtpVerification(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('tailor/otp-verification', body, headers: {
      'accept': 'application/json',
      /*'Authorization': "Bearer $accessToken",*/
    });
    if (res.statusCode == 200) {
      print("Login Response is : ${res.statusCode.toString()}");
      return OtpVerificationResponseModel.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //3). For Getting Current Tailor Details
  Future<Current_Tailor_Response> getCurrentTailorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('tailor/getCurrentTailor', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Current_Tailor_Response.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //4). For Getting Specific Customer's Measurement  Details
  Future<Specific_Cutomer_Measurement_Response_Model> getSpecificCustomerMeasurementDetails(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("User Access Token Value is : $customerId");
    httpClient.baseUrl = apiBaseUrl;

    var res = await get('customer/getSpecificCustomersDetails/$customerId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Tailor Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Specific_Cutomer_Measurement_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //5). For Getting Specific Customer Dress Details
  Future<Specific_Customer_Dress_Details_Model> getSpecificCustomerDressDetails(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("User Access Token Value is : $customerId");
    httpClient.baseUrl = apiBaseUrl;

    var res = await get('customer/getSpecificCustomerOrders/$customerId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Tailor Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Specific_Customer_Dress_Details_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //6). For Updating Measurement Details
  Future<Update_Customer_Measurement_Details_Model> updateCustomerMeasurementDressDetails(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $body");
    var res = await put('customer/updateCustomerMeasurements', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      print("Update Measurement Response is : ${res.statusCode.toString()}");
      return Update_Customer_Measurement_Details_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //7). For Verifying Measurement Details
  Future<Mobile_Verify_Model> verifyCustomerMobile(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $body");
    var res = await post('customer/verifyCustomerMobileNo', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Response is ${res.statusCode.toString()}");
    if (res.statusCode == 200) {
      print("Update Measurement Response is : ${res.statusCode.toString()}");
      return Mobile_Verify_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //8). For Updating The Dress Status
  Future<Order_Status_Change_Model> updateDreesOrderStatus(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $body");
    var res = await post('order/changeOrderStatus', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Map Value is ${res.body}");
    if (res.statusCode == 200) {
      print("Update Measurement Response is : ${res.statusCode.toString()}");
      return Order_Status_Change_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //9). For Getting The Specific Dress Details
  Future<Specific_Order_Detail_Response_Model> getSpecificDreesDetails(String dressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $dressId");
    var res = await get('order/getSpecificOrderDetails/$dressId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Map Value is ${res.body}");
    if (res.statusCode == 200) {
      print("Update Measurement Response is : ${res.statusCode.toString()}");
      return Specific_Order_Detail_Response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //10). For Updating The Dress Status
  Future<CustomerDeleteResponseModel> removeCustomerFromList(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $body");
    var res = await post('tailor/removeCustomerFromTailor', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Map Value is ${res.body}");
    print("Map Value is ${res.statusCode}");
    if (res.statusCode == 200) {
      print("Update Delete Customer Response is : ${res.statusCode.toString()}");
      return CustomerDeleteResponseModel.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }



  //Customer
//1). For Getting Otp(For Customer)
  Future<LoginResponseModel> customerLogin(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('customer/login', body, headers: {
      'accept': 'application/json',
      /*'Authorization': "Bearer $accessToken",*/
    });
    if (res.statusCode == 200) {
      print("Login Response is : ${res.statusCode.toString()}");
      return LoginResponseModel.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //2). For Verifying Otp
  Future<Customer_Otp_Verification_Model> customerOtpVerification(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('customer/otp-verification', body, headers: {
      'accept': 'application/json',
      /*'Authorization': "Bearer $accessToken",*/
    });
    if (res.statusCode == 200) {
      print("Login Response is : ${res.statusCode.toString()}");
      return Customer_Otp_Verification_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //3). For updating details in profile of customer
  Future<Update_Customer_Profile_response_Model> customerUpdateProfile(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("Customer Access Token is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("base url is $apiBaseUrl");
    print("base url is $body");
    var res = await put('customer/updateCustomerDetails', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Otp Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      print("Login Response is : ${res.statusCode.toString()}");
      return Update_Customer_Profile_response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //4. For Getting Current Customer Details
  Future<Current_Customer_response_Model> getCurrentCustomerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('customer/getCurrentCustomer', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Current_Customer_response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


  //5. For Getting All tailors list
  Future<Get_All_Tailors_response_Model> getAllTailorsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('tailor/getAllTailors', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Get_All_Tailors_response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //6). For Getting My Tailor List And Order List
  Future<Get_Current_Customer_Response_Model> getMyTailorList_order() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('customer/getCurrentCustomer', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Get_Current_Customer_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //7). For Getting Specific Customer Dress Details
  Future<Specific_Customer_Dress_Detail_Response_Model> getCustomerSpecificDressDetail(String dressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('order/getSpecificOrderDetails/$dressId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Specific_Customer_Dress_Detail_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

}