
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myimmoappfahad/corps/userinterface.dart';

class ServerHandler {
  String IP = '';
  Map<String, String> Headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  String Request;
  Map<String, dynamic> sendData;
  ServerHandler({required this.Request, required this.sendData});

  Future<String> LoginUser() async {
    try {
      Uri request_url = Uri.parse("$IP/$Request");
      final response = await http.post(request_url,
          headers: Headers, body: jsonEncode(sendData));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        UserData userData = UserData();
        userData.token = responseMap['token'];
        return responseMap['token'].toString();
      } else {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        if (responseMap['token'] == 'no_user') {
          return 'no_user';
        }
      }
    } catch (e) {
      print('during run error');
      return 'error';
    }
    return 'error';
  }

  Future<String> RegisterUser() async {
    try {
      Uri request_url = Uri.parse("$IP/$Request");
      final response = await http.post(request_url,
          headers: Headers, body: jsonEncode(sendData));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        UserData userData = UserData();
        userData.token = responseMap['token'];
        return responseMap['token'].toString();
      } else {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        if (responseMap["message"] == 'Username-already-exists') {
          return 'already_exist';
        }
      }
    } catch (a) {
      print('during run error');
      return 'error';
    }
    return 'error';
  }
}
