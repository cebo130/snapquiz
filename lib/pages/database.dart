import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // Future addEmployeeDetails(Map<String, dynamic> employeeInfoMap) async {
  //   return await FirebaseFirestore.instance
  //       .collection("Employee")
  //       .doc()
  //       .set(employeeInfoMap);
  // }

  // Future getAllUsers() async {
  //   return await FirebaseFirestore.instance.collection("users").doc().get();
  // }
  Future addUserDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc()
        .set(userInfoMap);
  }

  Future<List<DocumentSnapshot>> getAllUsers() async {
    var snapshot = await FirebaseFirestore.instance.collection("users").get();
    return snapshot.docs;
  }

  Future<QuerySnapshot> getthisUserInfo(String name) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .get();
  }

  Future UpdateUserData(String age, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Age": age});
  }

  Future DeleteUserData(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
  }
}
