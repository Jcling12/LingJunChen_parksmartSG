import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_parksmartsg/authenticate.dart';

final authentication = AuthService();
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore database = FirebaseFirestore.instance;
Map<String, dynamic>? userData;
String? parkingKey;
int? parkedLength;
bool noData = false;

class ParkingPage extends StatefulWidget {
  const ParkingPage({super.key});

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await database.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;

          if (userData!.containsKey('parked-spaces')) {
            Map<String, dynamic> parkedSpace = userData?['parked-spaces'];
            parkingKey = parkedSpace.values.first;
            parkedLength = parkedSpace['$parkingKey'].length;
          }
          if (parkedLength == 0) {
            noData = true;
          }
        });
      } else {
        print("No user data found.");
      }
    }
  }

  Future<Map<String, dynamic>?> fetchData2() async {
    final collectionRef = database.collection('available-spaces');
    final querySnapshot = await collectionRef.doc(parkingKey).get();

    return querySnapshot.data();
  }

  Future<void> updateParkingLot(dynamic parkingID) async {
    User? user = auth.currentUser;
    final collectionRef = database.collection('users').doc(user?.uid);

    await collectionRef.update({
      'parked-spaces.$parkingKey': FieldValue.arrayRemove([parkingID])
    });

    final collectionRef2 =
        database.collection('${parkingKey}_parking-lots').doc('Section1');
    final querySnapshot = await collectionRef2.get();

    Map<String, dynamic> sectionData = querySnapshot.data() as Map<String, dynamic>;
    
    String? lotKey;
    for (int i = 1; i < sectionData.length; i++) {
      sectionData["lot$i"].forEach((key, value) {
        if (key == 'id' && value.toString() == parkingID) {
          lotKey = "lot$i";
        }
      });
    }

    if (lotKey == null) return;

    // Update the availability of the selected lot
    await collectionRef2.update({
      '$lotKey.available': true, // Set availability to false
    });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Successfully cancelled!"),
            content: const Text("Return to home"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchData2(),
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle errors
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data;

        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 15, 103, 253),
                            width: 2.0)),
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  controller: searchController,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.fromLTRB(26, 5, 0, 0),
                  child: Text(
                    'Parked Spaces',
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Gilroy-Bold',
                        color: Color.fromARGB(255, 15, 103, 253)),
                  )),
              Container(
                  height: MediaQuery.of(context).size.height - 340,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                      itemCount: parkedLength,
                      itemBuilder: (context, index) {
                        var parkingID =
                            userData?['parked-spaces']['$parkingKey'][index];
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                height: 160,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: (Colors.grey[300])!,
                                        blurRadius: 30.0,
                                        offset: const Offset(10, 10),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'images/${data?['pic']}.jpg',
                                        width: 130,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 8, 0, 0),
                                          child: Text(
                                            data?['name'] ?? 'No Name',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Gilroy-Bold',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 2, 0, 0),
                                          child: Text(
                                            "+65 ${data?['contact'] ?? 'No Mobile'}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Gilroy-Regular',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child: Text(
                                            "Parking Lot: ${userData?['parked-spaces']['$parkingKey'][index]}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Gilroy-Regular',
                                                color: Color.fromARGB(
                                                    255, 15, 103, 253)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              updateParkingLot(parkingID);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 0)),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontFamily: 'Gilroy-Bold',
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })),
            ]);
      },
    );
  }
}
