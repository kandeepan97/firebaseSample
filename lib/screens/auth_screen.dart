import 'package:Peak_Point/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reTypePasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLogIn = true;
  var _isLoading = false;
  String _dropdownValue = 'Select Role';

  _submitForm({
    String userName,
    String roleName,
    String email,
    String password,
    BuildContext context,
  }) {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        if (_isLogIn) {
          FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
          
              .then((_) {
            setState(() {
              _isLoading = false;
            });

            _emailController.clear();
            _passwordController.clear();

            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          }).catchError((error) {
            setState(() {
              _isLoading = false;
            });

            _emailController.clear();
            _passwordController.clear();

            print(error.message);
          });
        } else {
          FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
          
              .then((_) {
            setState(() {
              _isLoading = false;
            });

            _nameController.clear();
            _emailController.clear();
            _passwordController.clear();
            _reTypePasswordController.clear();

            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          }).catchError((error) {
            setState(() {
              _isLoading = false;
            });

            _nameController.clear();
            _emailController.clear();
            _passwordController.clear();
            _reTypePasswordController.clear();

            print(error.message);
          });
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });

        print(error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100.0),
                      child: Text(
                        _isLogIn ? 'SIGN IN' : 'SIGN UP',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arima',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: _isPortrait ? 260.0 : 200.0),
                      padding: EdgeInsets.symmetric(
                          horizontal: _isPortrait ? 30.0 : 80.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_isLogIn)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    errorStyle: TextStyle(height: 0.1),
                                    border: InputBorder.none,
                                    hintText: 'Username',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      size: 30.0,
                                    ),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter your name';
                                    } else if (value.trim().length < 4) {
                                      return 'Username must be atleast 4 letters long';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            SizedBox(height: 20.0),
                            if (!_isLogIn)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: DropdownButtonFormField(
                                  value: _dropdownValue,
                                  icon: Container(
                                    margin: const EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.expand_more),
                                  ),
                                  iconSize: 30.0,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16.0,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    errorStyle: TextStyle(height: 0.1),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.account_box),
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Select Role',
                                    'Organization',
                                    'Donator',
                                    'Receiver',
                                    'Delivery man',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == 'Select Role') {
                                      return 'Please select user role';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            SizedBox(height: _isLogIn ? 50.0 : 20.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  errorStyle: TextStyle(height: 0.1),
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    size: 30.0,
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your email address';
                                  } else if (!value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  errorStyle: TextStyle(height: 0.1),
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    size: 30.0,
                                  ),
                                ),
                                obscureText: true,
                                textInputAction: _isLogIn
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (value.trim().length < 7) {
                                    return 'Password must be atleast 7 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: _isLogIn ? 5.0 : 20.0),
                            if (!_isLogIn)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: _reTypePasswordController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    errorStyle: TextStyle(height: 0.1),
                                    border: InputBorder.none,
                                    hintText: 'Re-type Password',
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      size: 30.0,
                                    ),
                                  ),
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please re-type your password';
                                    } else if (value.trim() !=
                                        _passwordController.text.trim()) {
                                      return 'Password did\'t match, Please re-enter password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            if (!_isLogIn) SizedBox(height: 10.0),
                            if (_isLogIn)
                              Container(
                                alignment: Alignment.bottomRight,
                                child: FlatButton(
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onPressed: () {
                                    
                                  },
                                ),
                              ),
                            SizedBox(height: _isLogIn ? 40.0 : 30.0),
                            _isLoading
                                ? CircularProgressIndicator()
                                : Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(30.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: FlatButton(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15.0),
                                      child: Text(
                                        _isLogIn ? 'SIGN IN' : 'SIGN UP',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        _submitForm(
                                          userName: _nameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                          roleName: _dropdownValue,
                                          context: context,
                                        );
                                      },
                                    ),
                                  ),
                            SizedBox(height: 30.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLogIn)
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100.0,
                        child: Divider(
                          color: Colors.grey[900],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[900],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      SizedBox(
                        width: 100.0,
                        child: Divider(
                          color: Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isLogIn)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 15.0,
                    top: 10.0,
                  ),
                  child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.grey[300],
                    onPressed: () {
                      
                    },
                    icon: Icon(
                      Icons.access_alarm,
                      color: Colors.deepOrange,
                    ),
                    label: Text('Sign in with google'),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              _isLogIn ? 'Don\'t have an account?' : 'Already have an account?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            FlatButton(
              child: Text(
                _isLogIn ? 'SIGN UP' : 'SIGN IN',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  _isLogIn = !_isLogIn;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
