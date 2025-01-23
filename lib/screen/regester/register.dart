import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/regester/cubit.dart';
import '../../cubits/regester/state.dart';
import '../app/HomeScreen.dart';
import 'login.dart';
class RegisterWeb extends StatefulWidget {
  @override
  _RegisterWebState createState() => _RegisterWebState();
}

class _RegisterWebState extends State<RegisterWeb> {
  final nameController = TextEditingController();
  final c_passwordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 800;

    return BlocConsumer<registerCubit,registerSates>(
      listener: (BuildContext context, registerSates state) {
        if (state is SignupSuccessState){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Login()
            ),
          );

        }
        else

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Login()
            ),
          );
          print('oops ');
      },
      builder: (BuildContext context, registerSates state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: isLargeScreen ? 700 : screenSize.width * 0.9,
                padding: const EdgeInsets.all(24.0),
                decoration: isLargeScreen
                    ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                )
                    : null,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Let's Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Hey, enter your details to sign up.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 20),


                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),


                      // TextFormField(
                      //   controller: phoneController,
                      //   decoration: InputDecoration(
                      //     prefixIcon: Icon(Icons.phone),
                      //     labelText: 'Phone',
                      //     hintText: 'Enter your phone',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter your phone number';
                      //     } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                      //       return 'Please enter a valid phone number';
                      //     }
                      //     return null;
                      //   },
                      // ),


                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),


                      TextFormField(
                        controller: passwordController,
                        obscureText: _isPasswordObscured,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                          ),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      TextFormField(
                        controller: c_passwordController,
                        obscureText: _isPasswordObscured,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                          ),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),


                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final cubit = registerCubit.get(context);
                              cubit.SignUp(
                                email: emailController.text,
                                password: passwordController.text,
                                c_password: passwordController.text,
                                name: nameController.text,

                              );
                              print('Form is valid');
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           HomeScreen()
                              //   ),
                              // );

                            } else {
                              print('Form is not valid');
                            }
                          },
                          child: Text(
                            'Sign Up',
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

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Login()
                                ),
                              );
                              print('Navigate to Login');
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
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
}
