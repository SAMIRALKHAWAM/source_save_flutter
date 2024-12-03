import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/regester/cubit.dart';
import '../../cubits/regester/state.dart';

class Code extends StatelessWidget {
  Code({required this.email});
  final String email;
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return BlocConsumer<registerCubit,registerSates>(
      listener: (BuildContext context, registerSates state) {  },
      builder: (BuildContext context, registerSates state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: isWeb ? MediaQuery.of(context).size.width * 0.3 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      Image.asset(
                        "assets/images/password_code.png",
                        height: isWeb ? 250 : 200,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Enter the Code',
                        style: TextStyle(
                          fontSize: isWeb ? 32 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Please enter the code sent to $email',
                        style: TextStyle(
                          fontSize: isWeb ? 16 : 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      _buildCodeField(codeController, isWeb),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              registerCubit.get(context).verify_account(code: codeController.text, email: email);

                            }
                          },
                          child: Text(
                            'Next',
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
                      SizedBox(height: 15),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not Received Code?",
                              style: TextStyle(
                                fontSize: isWeb ? 16 : 14,
                                color: Colors.black45,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Resend code logic here
                              },
                              child: Text(
                                "Resend",
                                style: TextStyle(
                                  fontSize: isWeb ? 16 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }

  Widget _buildCodeField(TextEditingController controller, bool isWeb) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Code",
        hintText: "Enter your code",
        hintStyle: TextStyle(color: Colors.grey[400]),
        labelStyle: TextStyle(color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the code';
        }
        return null;
      },
    );
  }
}
