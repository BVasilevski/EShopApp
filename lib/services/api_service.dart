import 'dart:convert';
import 'package:e_shop_app/models/user.dart';
import 'package:http/http.dart' as http;

import '../models/item.dart';
var baseUrl = 'https://onlineshop-production-43c7.up.railway.app/api/';

class ApiService {

  static Future<http.Response> getItemsByCategory(String category) async {
    var response = await http.get(Uri.parse("${baseUrl}items?category=$category"));
    return response;
  }

  static Future<http.Response> getCartItems(String userId) async {
    var response = await http.get(Uri.parse("${baseUrl}cart?userId=$userId"));
    return response;
  }

  static Future<http.Response> getOrders(String userId) async {
    var response = await http.get(Uri.parse("${baseUrl}orders?userId=$userId"));
    return response;
  }

  static Future<Item?> getDetailsForItem(int itemId) async {
    try {
      var response = await http.get(Uri.parse("${baseUrl}items/$itemId"));
      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        Map<String, dynamic> data = json.decode(response.body);
        return Item.fromJson(data);
      } else {
        print("Failed to fetch item. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching item: $e");
      return null;
    }
  }


  static Future<void> createOrder(String userId) async {

    final response = await http.post(
      Uri.parse("${baseUrl}orders/create"),
      body: {
        'userId': userId,
        },
    );
    print(response.statusCode);

 }

  static Future<void> removeItemFromCart(int itemId) async {

    final response = await http.delete(
      Uri.parse("${baseUrl}cart/remove_from_cart"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'itemId': itemId.toString()},
    );
    print(response.statusCode);

 }

  static Future<void> addItemFromCart(int itemId, String userId) async {
    int userid = int.parse(userId);
    final response = await http.post(
      Uri.parse("${baseUrl}cart/add_to_cart"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        'itemId': itemId.toString(),
        'userId': userid.toString(),
        'quantity': '1'
        },
    );
    print(response.statusCode);

 }

 static Future<User> getUserInformation(String? userId) async {
  var response = await http.get(Uri.parse("${baseUrl}users"));

  if (response.statusCode != 200) {
    throw Exception("Failed to fetch users: ${response.statusCode}");
  }

  List<dynamic> users = jsonDecode(response.body);
  var user = users.firstWhere(
    (user) => user['id'].toString() == userId,
  );
  print(User.fromJson(user));

  return User.fromJson(user);
}

  static Future<String> logIn(String email, String password) async {

    final url = Uri.parse("${baseUrl}users/login");
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String userId = responseData['userId'].toString();
      return userId;
    }
    return 'null';

  }

  static Future<int> create(String email, String password, String firstName, String lastName) async {
    final url = Uri.parse("${baseUrl}users/create");
    final response = await http.post(
      url,
      body: {
        'email': email,
        'name': firstName,
        'lastName': lastName,
        'password': password,
      },
    );
    return response.statusCode;
  }

  static Future<bool> editUser(String userId, String email,String firstNameAndLastName) async {
    var names = firstNameAndLastName.split(" ");
    String firstName = names[0];
    String lastName = names[1];
    final url = Uri.parse("${baseUrl}users/edit/$userId");
    final response = await http.post(
      url,
      body: {
        'email': email,
        'name': firstName,
        'lastName': lastName,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Error updating user: ${response.body}");
      return false;
    }
  }

  static Future<bool> addRatingForItem(int itemId, String userId, int rating, String comment, String imageUrl) async {
    var url = Uri.parse("${baseUrl}items/rate/$itemId?userId=$userId&rating=$rating&comment=$comment&userImageUrl=$imageUrl");
    final response = await http.post(url);
    return response.statusCode == 200 ? true : false;
  }

  static Future<bool> cancelOrder(int orderId, String userId) async {
    var url = Uri.parse("${baseUrl}orders/cancel/$orderId?userId=$userId");
    final response = await http.delete(url);
    return response.statusCode == 200 ? true : false;
  }
}