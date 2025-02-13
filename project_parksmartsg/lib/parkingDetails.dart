import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_parksmartsg/authenticate.dart';

final authentication = AuthService();
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore database = FirebaseFirestore.instance;

class DetailsPage extends StatefulWidget {
  final String parkingName;
  final String mobile;
  final String address;
  final String collectionName;
  const DetailsPage(
      {super.key,
      required this.parkingName,
      required this.mobile,
      required this.address,
      required this.collectionName});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String? SelectedLotId;
  bool btnEnable = true;

  Future<List<Map<String, dynamic>>> fetch() async {
    final collectionRef =
        database.collection('${widget.collectionName}_parking-lots');
    final querySnapshot = await collectionRef.get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> bookParkingLot() async {
    final collectionRef = database
        .collection('${widget.collectionName}_parking-lots')
        .doc('Section1');
    final querySnapshot = await collectionRef.get();

    Map<String, dynamic> sectionData =
        querySnapshot.data() as Map<String, dynamic>;

    String? lotKey;
    for (int i = 1; i < sectionData.length; i++) {
      sectionData["lot$i"].forEach((key, value) {
        if (key == 'id' && value.toString() == SelectedLotId) {
          lotKey = "lot$i";
        }
      });
    }

    if (lotKey == null) return;

    // Update the availability of the selected lot
    await collectionRef.update({
      '$lotKey.available': false, // Set availability to false
    });

    User? user = auth.currentUser;
    final collectionRef2 = database.collection('users').doc(user?.uid);
    await collectionRef2.update({
      'parked-spaces.${widget.collectionName}' : FieldValue.arrayUnion([SelectedLotId])
    });
    
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
           title: const Text("Successfully booked!"),
            content: const Text("Go to parking menu to see details\nClick 'Cancel' to cancel parking lot"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetch(),
          builder: (context, snapshot) {
            // Handle loading state
/*             if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } */

            // Handle errors
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Extract the list of documents
            final parkingLots = snapshot.data;

            if (parkingLots == null || parkingLots.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            return Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.parkingName}',
                          style: const TextStyle(
                              fontFamily: 'Gilroy-Bold',
                              fontSize: 26,
                              height: 0.5),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                      ],
                    ),
                    Text(
                      widget.address,
                      style: const TextStyle(
                          fontFamily: 'Gilroy-Regular',
                          fontSize: 16,
                          height: 0.5),
                    ),
                    Text(
                      "+65 ${widget.mobile}",
                      style: const TextStyle(
                          fontFamily: 'Gilroy-Regular',
                          fontSize: 16,
                          height: 2),
                    ),
                    SizedBox(
                      height: 490,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: parkingLots[0].length,
                          itemBuilder: (context, index) {
                            final lot = parkingLots[0]["lot${index + 1}"];
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (lot['available'] == false) {
                                      SelectedLotId =
                                          'Cannot select parking lot';
                                    } else {
                                      SelectedLotId = lot['id'].toString();
                                    }

                                    if (SelectedLotId ==
                                        'Cannot select parking lot') {
                                      btnEnable = false;
                                    } else {
                                      btnEnable = true;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: lot['available']
                                        ? const Color.fromARGB(
                                            255, 15, 103, 253)
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/car-top.png',
                                        height: 50,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Lot ${lot['id']}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        lot['available']
                                            ? 'Available'
                                            : 'Occupied',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ));
                          }),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Selected Lot: $SelectedLotId',
                          style: const TextStyle(
                            fontFamily: 'Gilroy-Regular',
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 15, 103, 253),
                            padding: const EdgeInsets.all(10),
                            disabledBackgroundColor: Colors.white,
                          ),
                          onPressed: btnEnable
                              ? () {
                                  bookParkingLot();
                                }
                              : null,
                          child: Text(
                            btnEnable ? 'Book slot' : 'Cannot Book',
                            style: TextStyle(
                                color: btnEnable
                                    ? Colors.white
                                    : const Color.fromARGB(255, 15, 103, 253),
                                fontFamily: 'Gilroy-Bold',
                                fontSize: 20),
                          )),
                    )
                  ],
                ),
              ),
            );
          }),
    ));
  }
}
