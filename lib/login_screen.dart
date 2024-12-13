import 'package:flutter/material.dart';
import 'package:hedieatyyproject/home_page.dart';
import 'package:hedieatyyproject/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isSignUp = false;
  bool isLoading = false;

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        if (isSignUp) {
          await _authService.signUp(email, password);
        } else {
          await _authService.signIn(email, password);
        }

        // Navigate to HomePage after successful login/signup
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );*/
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSignUp ? 'Sign Up' : 'Login',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isSignUp ? 'Create Account' : 'Welcome Back',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                            ),
                            onChanged: (val) => email = val,
                            validator: (val) =>
                            val!.isEmpty ? 'Enter a valid email' : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                            ),
                            obscureText: true,
                            onChanged: (val) => password = val,
                            validator: (val) => val!.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                          ),
                          SizedBox(height: 20),
                          isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                            onPressed: handleSubmit,
                            child: Text(
                              isSignUp ? 'Sign Up' : 'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isSignUp = !isSignUp;
                              });
                            },
                            child: Text(
                              isSignUp
                                  ? 'Already have an account? Login'
                                  : 'Don’t have an account? Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
