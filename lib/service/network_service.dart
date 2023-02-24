import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:network/service/utils_service.dart';
import '../models/employee_model.dart';
import '../network/api.dart';
import 'log_service.dart';

class EmployeeServices {

  static Future<List<Datum>> getEmployees(BuildContext context) async {
    try {
      Uri uri = Uri.http(Urls.BASE_URL, Urls.API_LIST );
      var response = await get(uri);

      Log.e(response.statusCode.toString());

      if(response.statusCode == 200 || response.statusCode == 201){
        Log.w(response.body);

        Map<String, dynamic> responseMap = json.decode(response.body);

        return (responseMap['data'] as List)
            .map((e) => Datum.fromJson(e))
            .toList();
      }
      if(response.statusCode == 429){
        Utils.snackBarError('Too many request', context);
      }

    } catch (e) {
      Log.e(e.toString());
    }
    throw Exception('');
  }

  static Future<String?> apiOneEmployee(int id) async {
    try {
      Uri uri = Uri.http(Urls.BASE_URL, Urls.API_ONE_ELEMENT + id.toString());
      var response = await get(uri);

      Log.w(response.statusCode.toString());
      if(response.statusCode == 200 || response.statusCode == 201){
        Log.i(response.body);
        return response.body.toString();
      }
      if(response.statusCode == 429){
        return 'Too many requests';
      }

    } catch (e) {
      Log.e(e.toString());
    }
    return null;
  }

  static Future<String?> createEmployee(String name, String salary, String age) async {
    try {
      Uri uri = Uri.http(Urls.BASE_URL, Urls.API_CREATE);
      var response = await post(
        uri,
        body: {
          "name": name,
          "salary": salary,
          "age": age
        },
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        Map<String, dynamic> responseMap = json.decode(response.body);
        return responseMap['status'];
      }
      Log.i(response.body);
      return 'success';


    } catch (e) {
      Log.e(e.toString());
    }
  }

  static Future<void> uptadeEmployee(String name, int salary, int age, int id) async {
    try {
      Uri uri = Uri.http(Urls.BASE_URL, Urls.API_UPDATE + id.toString());
      var response = await put(
        uri,
        body: {
          "name": "John",
          "salary": "12000",
          "age": "20"
        }
      );
      Log.w(response.statusCode.toString());
      Log.i(response.body);
    } catch (e) {
      Log.e(e.toString());
    }
  }

  static Future<String?> deleteEmployee(int id) async {
    try {
      Uri uri = Uri.http(Urls.BASE_URL, Urls.API_DELETE + id.toString());
      var response = await delete(uri);

      if(response.statusCode == 200 || response.statusCode == 201){
        Map<String, dynamic> responseMap = json.decode(response.body);
        return responseMap['status'];
      }
      Log.i(response.body);
      return 'success';

    } catch (e) {
      Log.e(e.toString());
    }
  }

}