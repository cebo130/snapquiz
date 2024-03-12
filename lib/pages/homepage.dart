import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot> _stream;
  bool correct = false;
  bool pressed = false;
  Color? myCol = Colors.grey;
  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('quiz').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Stream Example2'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final questionText = document["questionText"];
              final correctOption = document["correctOption"];
              final options = Map<String, dynamic>.from(document["options"]);

              // Sort the map entries by key in ascending order
              final sortedOptions = options.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key));

              return Column(
                children: [
                  Text(questionText),
                  SizedBox(height: 10,),
                  Column(
                    children: sortedOptions.map((entry) {
                      final key = entry.key;
                      final value = entry.value;
                      return GestureDetector(
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: pressed ? correct ? Colors.green :Colors.red : myCol,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            child: Text('$key: $value')
                        ),
                        onTap: (){

                          setState(() {
                            pressed=true;
                          });
                          if(key==correctOption){
                            setState(() {
                              correct=true;
                              print("i am working ======+++**************************");
                              print(correct);
                            });
                          }else{
                            pressed=false;
                            correct=false;
                          }
                        },
                      );
                    }).toList(),
                  ),
                  Text(correctOption),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
