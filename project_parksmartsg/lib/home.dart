import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_parksmartsg/authenticate.dart';

import 'package:project_parksmartsg/parking.dart';
import 'package:project_parksmartsg/profile.dart';
import 'package:project_parksmartsg/about.dart';
import 'package:project_parksmartsg/parkingDetails.dart';

final authentication = AuthService();
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore database = FirebaseFirestore.instance;
Map<String, dynamic>? userData;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  var data = [];
  dynamic details;
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
        });
      } else {
        print("No user data found.");
      }
    }
  }

  final List<Widget> pages = [
    const HomePage2(),
    const ParkingPage(),
    const ProfilePage(),
    const AboutPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Set this height
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 30,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('images/james-goh.jpg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "${userData?['name']}",
                          style: const TextStyle(
                            fontFamily: 'Gilroy-Bold',
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  Image.asset('images/logo-horizontal.png')
                ],
              )),
        ),
      ),
      body: Center(child: pages[currentPage]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
            color: (Colors.grey[300])!,
            blurRadius: 30.0,
            offset: const Offset(15, 15),
          )
        ]),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipPath(
              clipper: const ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)))),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                selectedItemColor: const Color.fromARGB(255, 15, 103, 253),
                unselectedItemColor: Colors.grey,
                currentIndex: currentPage,
                onTap: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    label: "Home",
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.local_parking,
                      size: 30,
                    ),
                    label: "Parking",
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    label: "Profile",
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.info_outline,
                      size: 30,
                    ),
                    label: "About",
                    backgroundColor: Colors.white,
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final TextEditingController searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> fetchData2() async {
    final collectionRef = database.collection('available-spaces');
    final querySnapshot = await collectionRef.get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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

        // Extract the list of documents
        final parkingLocations = snapshot.data;

        //if (parkingLocations == null || parkingLocations.isEmpty) {
        //return Center(child: Text('No data available.'));
        //}

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
                    'Recent Places',
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
                    itemCount: parkingLocations?.length,
                    itemBuilder: (context, index) {
                      final location = parkingLocations?[index];
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
                                      'images/${location?['pic']}.jpg',
                                      width: 130,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 0, 0),
                                        child: Text(
                                          location?['name'] ?? 'No Name',
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
                                          "+65 ${location?['contact'] ?? 'No Mobile'}",
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
                                          "${location?['address'] ?? 'No Address'}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Gilroy-Regular',
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                170,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 0, 0),
                                              child: Text(
                                                "\$${location?['priceRate'] ?? 0}/hr",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Gilroy-Bold',
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailsPage(
                                                                parkingName:
                                                                    "${location?['name']}",
                                                                mobile:
                                                                    "${location?['contact']}",
                                                                address:
                                                                    "${location?['address']}",
                                                                collectionName:
                                                                    "${location?['pic']}",
                                                              )));
                                                },
                                                icon: const Icon(
                                                  Icons.forward,
                                                  size: 30,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child: Text(
                                            "${location?['spaces'] ?? 0} free spaces",
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontFamily: 'Gilroy-Bold',
                                            ),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ]);
      },
    );
  }
}
