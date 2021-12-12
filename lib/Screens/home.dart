import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final TextEditingController _textFieldController = TextEditingController();
  // final List<String> _todos = <String>[];

  TextEditingController taskconroller = TextEditingController();

  addData() async {
    await FirebaseFirestore.instance.collection('task').add({
      'task': taskconroller.text,
      'date':
          '${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}-'
    });

    taskconroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("TODO FIREBASE"),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: taskconroller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter list Here',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Add to List'),
                    onPressed: () {
                      addData();
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Remove from List'),
                    onPressed: () {}),
              ),
            ],
          ),
          // Expanded(
          //     child: StreamBuilder<QuerySnapshot>(
          //   stream: FirebaseFirestore.instance.collection('task').snapshots(),
          //   builder:
          //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.hasError) {
          //       return Text("ERROR");
          //     }
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }

          //     return ListView(
          // children: snapshot.data!.docs.map((DocumentSnapshot document) {
          // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          //   return ListTile(
          //     title: Text(data['full_name']),
          //     subtitle: Text(data['company']),
          //   );
          // }).toList(),
          //     );

          //       ],

          //   },
          // ),

          // )

          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('task').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            title: Text(data['task']),
                            subtitle: Text(data['date']),
                            trailing: Wrap(
                              spacing: 1,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      document.reference.delete();
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Update Task"),
                                              content: Column(
                                                children: [
                                                  TextField(
                                                    controller:
                                                        taskEditcontroller,
                                                  ),
                                                  RaisedButton(
                                                    onPressed: () {
                                                      document.reference
                                                          .update({
                                                        'task':
                                                            taskEditcontroller
                                                                .text
                                                      });
                                                      Navigator.pop(context);
                                                      taskEditcontroller
                                                          .clear();
                                                    },
                                                    child: Text("update"),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.edit)),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return CircularProgressIndicator();
                  }))
        ],
      )),
    );
  }
}

TextEditingController taskEditcontroller = TextEditingController();
