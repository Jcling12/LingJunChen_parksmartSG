import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 190,
              child: Stack(children: [
                Positioned(
                  right: 90,
                  top: 90,
                  width: 100,
                  child: Image.asset('images/login-pic.png'),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(child: Image.asset('images/logo.png')),
                )
              ]),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'About Us',
                style: TextStyle(
                    color: Color.fromARGB(255, 15, 103, 253),
                    fontFamily: 'Gilroy-Bold',
                    fontSize: 28),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'ParkSmartSG connects drivers to real-time parking, allowing you to locate and reserve parking spots at your convenience.\nWith features like live availability updates, seamless navigation, and secure bookings, we aim to transform the way you park.',
                style: TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Contact Info',
                style: TextStyle(
                    color: Color.fromARGB(255, 15, 103, 253),
                    fontFamily: 'Gilroy-Bold',
                    fontSize: 28),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 62,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('images/andrey-lim.jpg'),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        'Ling Jun Chen',
                        style: TextStyle(
                            fontFamily: 'Gilroy-Bold',
                            fontSize: 26,
                            height: 1.2),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        'CEO, ParkSmart Holdings Pte Ltd',
                        style: TextStyle(
                            fontFamily: 'Gilroy-Bold', fontSize: 14, height: 1),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                          child: Icon(
                            Icons.call,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final Uri uri = Uri(
                              scheme: 'tel',
                              path: "8854 8322",
                            );
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              print('cannot launch');
                            }
                          },
                          child: const Text(
                            '+65 8854 8322',
                            style: TextStyle(
                                fontFamily: 'Gilroy-Regular', fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          child: Icon(
                            Icons.email,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String? encodeQueryParameters(
                                Map<String, String> params) {
                              return params.entries
                                  .map((MapEntry<String, String> e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                  .join('&');
                            }

                            final Uri uri = Uri(
                              scheme: 'mailto',
                              path: "jcling.sg@yahoo.com",
                              query: encodeQueryParameters(<String, String> {
                                'subject' : 'Write a subject',
                                'body' : 'Write description'
                              })
                            );
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              print('cannot launch');
                            }
                          },
                          child: const Text(
                            'jcling.sg@yahoo.com',
                            style: TextStyle(
                                fontFamily: 'Gilroy-Regular', fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
          ]),
    );
  }
}
