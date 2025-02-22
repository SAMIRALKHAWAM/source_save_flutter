import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/screen/regester/register.dart';

import '../../cubits/regester/cubit.dart';
import '../../cubits/regester/state.dart';
import '../../network/cash_helper.dart';
import '../../network/end_point.dart';
import '../admain/homescreen.dart';
import '../app/HomeScreen.dart';
import 'forget.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

        if (state is LoginSuccessState){

          CachHelper.saveData(key: "token", value: registerCubit.get(context).loginmodel.data.token.toString());
          CachHelper.saveData(key: "id", value: registerCubit.get(context).loginmodel.data.id.toString());
          CachHelper.saveData(key: "role", value: registerCubit.get(context).loginmodel.data.role.toString());

          token=CachHelper.getData(key: "token");
          id=CachHelper.getData(key: "id");
          role=CachHelper.getData(key: "role");
        role=="admin"?
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AdminHomeScreen()
            ),
          ):


          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen()
            ),
          );

        }
      },
      builder: ( context,  state) {
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
                        "Let's Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.purple[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Hey, enter your details to sign in to your account.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 30),


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


                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgetPassword()
                              ),
                            );

                            print('Navigate to Forget Password');
                          },
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.purple[800],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),


                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, proceed with login logic
                              print('Form is valid');
                              registerCubit.get(context).SignIn(
                                  email: emailController.text,
                                  password: passwordController.text
                              );



                            } else {
                              print('Form is not valid');
                            }
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[800],
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
                            "Don't have an account? ",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterWeb()
                                ),
                              );


                              print('Navigate to Sign Up');
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[800],
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
