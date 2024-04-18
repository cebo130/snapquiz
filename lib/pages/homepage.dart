import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snapquiz/pages/database.dart';

import '../widgets/pickers/user_image.dart';
import 'edit_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  List<String> tMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  DateTime date = DateTime.now();
  var myDay = Timestamp.now().toDate().day;
  int myMonth = Timestamp.now().toDate().month;
  var myYear = Timestamp.now().toDate().year;
  var myDtime = Timestamp.now().toDate().hour;
  String nowTime =
      "${Timestamp.now().toDate().hour} : ${Timestamp.now().toDate().minute}";

  File? pImageFile;
  String userImageUrl = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
  late Stream<QuerySnapshot> _usersStream;

  void _pickedImage(File image) {
    pImageFile = image;
  }

  bool addImage = false;
  //  uploadToStorage(String myPostImageUrl)async{
  //
  // }
  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance
        .collection("users")
        .orderBy('timeTool', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    String dateFormat = DateFormat('EEEE').format(date);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "my",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "WorkLife",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 180,
              height: 32,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey[100]!),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "search",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey[100]!),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // Text("${index}"),
                        SizedBox(width: 5),
                        CircleAvatar(
                          backgroundImage: NetworkImage(user['userImageUrl']),
                          radius: 28,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['name']),
                            Text(
                              "${user['role']}",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              "${user['experience']} years",
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ],
                        ),
                        Spacer(),
                        PopupMenuButton(
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 5),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 5),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (dynamic value) {
                            if (value == "edit") {
                              _editUser(context, user);
                            } else if (value == "delete") {
                              _deleteUser(context, user.id);
                            }
                          },
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Add New User"),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UserImage(_pickedImage),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: _roleController,
                          decoration: InputDecoration(labelText: 'Role'),
                        ),
                        TextField(
                          controller: _experienceController,
                          decoration: InputDecoration(labelText: 'Experience'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        String name = _nameController.text.trim();
                        String role = _roleController.text.trim();
                        int experience =
                            int.tryParse(_experienceController.text.trim()) ??
                                0;

                        if (name.isNotEmpty &&
                            role.isNotEmpty &&
                            experience > 0) {
                          print("names are working ... ************");
                          print(name);
                          print(role);
                          print(experience);

                          if (pImageFile != null) {
                            try {
                              String cleanedName =
                                  _nameController.text.replaceAll(' ', '');
                              String cleanedRole =
                                  _roleController.text.replaceAll(' ', '');
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('user_images')
                                  .child(cleanedName + cleanedRole + '.png');
                              await ref.putFile(pImageFile!);
                              print('Uploading Image Done');
                              userImageUrl = await ref.getDownloadURL();
                              print("User Image Url: $userImageUrl");
                            } catch (e) {
                              print('Error uploading image: $e');
                            }
                          } else {
                            userImageUrl =
                                "https://cdn-icons-png.flaticon.com/512/149/149071.png";
                          }

                          // Call a function to add the user to Firestore
                          Map<String, dynamic> userInfoMap = {
                            "name": name,
                            "role": role,
                            "experience": experience,
                            "userImageUrl": userImageUrl,
                            'myTime':
                                " $myYear ◦ ${tMonths[myMonth - 1]} ◦ ${myDay} ◦ $dateFormat ~ $nowTime ◦",
                            'timeTool': FieldValue.serverTimestamp(),
                          };
                          DatabaseMethods().addUserDetails(userInfoMap);
                          _nameController.clear();
                          _roleController.clear();
                          _experienceController.clear();
                          Navigator.of(context).pop();
                        } else {
                          // Show an error message if any field is empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all fields.'),
                            ),
                          );
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _editUser(BuildContext context, DocumentSnapshot user) {
    // Navigate to edit screen, passing the user data
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditUserScreen(user: user),
    ));
  }

  void _deleteUser(BuildContext context, String userId) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User deleted")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to delete user")));
    }
  }
}
