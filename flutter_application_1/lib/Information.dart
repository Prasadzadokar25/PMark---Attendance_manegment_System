import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Information {
  String username = "prasadzadokars";
  String password = "";
  int teacherid = 0;

  static Information obj = Information();

  static Information getDataObject() {
    return obj;
  }

  int setInfo({required String username, required String password}) {
    obj.username = username;
    obj.password = password;
    fetchTeacherId();
    fetchClasses(obj.username);
    return 1;
  }

  String getUsername() {
    return obj.username;
  }

  String getPassword() {
    return obj.password;
  }

  String getTeacherId() {
    return "${obj.teacherid}";
  }

  Future<void> fetchTeacherId() async {
    final Map<String, dynamic> requestData = {'username': obj.username};

    final response = await http.post(
      Uri.parse('http://prasad25.pythonanywhere.com/get_teacher_id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      teacherid = responseData['id'];
      print(
          "-------------------------------------------------------------------$teacherid");
    } else {
      throw Exception('Failed to load teacher id');
    }
  }

  List<dynamic> classes = [];

  List<ModelClassData> classesObjList = [];

  Future<void> fetchClasses(String teacherName) async {
    final Map<String, dynamic> requestData = {'username': obj.username};
    print("here to call");
    final response = await http.post(
      Uri.parse('http://prasad25.pythonanywhere.com/classes'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );
    if (response.statusCode == 200) {
      log("in if===============");
      classes = jsonDecode(response.body);
    } else {
      Information.getDataObject().classes = [];

      log('this user has no class no server.......');
    }

    classesObjList = classes.map((map) => ModelClassData.getobj(map)).toList();
  }
}

class ModelClassData {
  int class_id;
  String class_name;
  String date_of_creation;
  int lectureCount;
  String subject_name;
  ModelClassData({
    required this.class_id,
    required this.class_name,
    required this.date_of_creation,
    required this.lectureCount,
    required this.subject_name,
  });
  static ModelClassData getobj(Map<String, dynamic> json) {
    return ModelClassData(
        class_id: json['class_id'],
        class_name: json['class_name'],
        date_of_creation: json['date_of_creation'],
        lectureCount: json["lectureCount"],
        subject_name: json["subject_name"]);
  }
}
