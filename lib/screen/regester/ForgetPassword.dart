import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool isCodeSent = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: screenWidth.width / 2,
                height: screenWidth.height,
                color: Colors.blue[800],
                child: Center(
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      isCodeSent ? "Enter the Code" : "Reset Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20),


                    Text(
                      isCodeSent
                          ? "We have sent a code to your email. Enter the code to reset your password."
                          : "Enter your email address to receive a code to reset your password.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 30),


                    if (!isCodeSent)
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),


                    if (isCodeSent)
                      TextField(
                        controller: codeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.code),
                          labelText: 'Enter Code',
                          hintText: 'Enter the code sent to your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                    if (isCodeSent)
                      Column(
                        children: [
                          SizedBox(height: 30),
                          TextField(
                            controller: newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'New Password',
                              hintText: 'Enter your new password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 30),


                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (!isCodeSent) {

                              print("Sending code to ${emailController.text}");
                              isCodeSent = true;
                            } else {

                              print("Verifying code and resetting password");
                            }
                          });
                        },
                        child: Text(
                          isCodeSent ? 'Reset Password' : 'Send Code',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
