import 'package:flutter/material.dart';
import 'package:project_parksmartsg/authenticate.dart';
import 'package:project_parksmartsg/login.dart';
import 'package:flutter/gestures.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final auth = AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool btnEnable = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  @override
  //Ensure widget is properly set up before method gets triggered
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {
        emailController.text.isEmpty ? btnEnable = false : btnEnable = true;
      });
    });
    emailController.addListener(() {
      setState(() {
        emailController.text.isEmpty ? btnEnable = false : btnEnable = true;
      });
    });
    passwordController.addListener(() {
      setState(() {
        passwordController.text.isEmpty ? btnEnable = false : btnEnable = true;
      });
    });
    phoneController.addListener(() {
      setState(() {
        passwordController.text.isEmpty ? btnEnable = false : btnEnable = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 103, 253),
        body: Stack(children: [
          Positioned(
            bottom: 0,
            right: 0,
            width: 200,
            child: Image.asset('images/login-pic.png'),
          ),
          Center(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 600,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.white)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: Image.asset(
                          "images/logo.png",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Hello there!',
                            style: TextStyle(
                              color: Color.fromARGB(255, 15, 103, 253),
                              fontFamily: 'Gilroy-Bold',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Create a username',
                            style: TextStyle(
                              fontFamily: 'Gilroy-Regular',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
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
                          controller: nameController,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Email Address',
                            style: TextStyle(
                              fontFamily: 'Gilroy-Regular',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
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
                          controller: emailController,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                              fontFamily: 'Gilroy-Regular',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 15, 103, 253),
                                    width: 2.0)),
                          ),
                          controller: phoneController,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontFamily: 'Gilroy-Regular',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 15, 103, 253),
                                    width: 2.0)),
                          ),
                          controller: passwordController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text.rich(TextSpan(
                                text: 'Existing User? Login ',
                                style: const TextStyle(
                                    fontFamily: 'Gilroy-Regular', fontSize: 12),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'here',
                                      style: const TextStyle(
                                          fontFamily: 'Gilroy-Regular',
                                          fontSize: 12,
                                          decoration: TextDecoration.underline),
                                      mouseCursor:
                                          WidgetStateMouseCursor.clickable,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const Login()),
                                            ).then((_) {
                                              emailController.clear();
                                              passwordController.clear();
                                            }))
                                ]))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                              onPressed: () async{
                                if (btnEnable == false) {
                                  auth.error(context, "Input fields are empty, please enter the fields.");
                                } else {
                                  await auth.createUser(nameController.text, emailController.text, phoneController.text, passwordController.text, context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 15, 103, 253),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    fontFamily: 'Gilroy-Bold', fontSize: 20),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
        resizeToAvoidBottomInset: false,
        );
  }


}
