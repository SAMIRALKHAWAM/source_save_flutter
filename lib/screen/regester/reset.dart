import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/regester/cubit.dart';
import '../../cubits/regester/state.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({required this.email, required this.code});
  final String email;
  final dynamic code;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordObscured = true;
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
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: isWeb ? MediaQuery.of(context).size.width * 0.2 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      Text(
                        "Create New Password",
                        style: TextStyle(
                          fontSize: isWeb ? 36 : 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Create a new password and please never share it with anyone for safe use',
                        style: TextStyle(
                          fontSize: isWeb ? 16 : 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      _buildPasswordField(passwordController, 'Password', isWeb),
                      SizedBox(height: 20),
                      _buildPasswordField(confirmPasswordController, 'Confirm Password', isWeb),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {

                            }
                          },
                          child: Text(
                            'Update Password',
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
            ),
          ),
        );

      },

    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool isWeb) {
    return TextFormField(
      controller: controller,
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
        ),
        labelText: label,
        hintText: 'Enter your $label',
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
          return 'Please enter your $label';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }
}
