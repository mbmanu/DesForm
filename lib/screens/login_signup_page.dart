import 'package:flutter/material.dart';
import '../services/authentication.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

var h = 15.0;

class LoginSignupPage extends StatelessWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: LoginSignUpPage(auth: auth, loginCallback: loginCallback,),
    );
  }
}

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new LoginSignUpPageState();
}

class LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading && _errorMessage == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    ScreenScaler scaler = ScreenScaler();

    return new Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Color(0xff2426a6),
              Theme.of(context).primaryColor
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showLogo(),
            new Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: scaler.getHeight(h),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20.0,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 8.0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          showEmailInput(),
                          showPasswordInput(),
                          showErrorMessage(),
                          showPrimaryButton(),
                          showSecondaryButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      h = 16.5;
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 5.0),
        child: new Text(
          _errorMessage,
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            fontFamily: 'Montserrat',
            height: 1.0,
          ),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    ScreenScaler scaler = ScreenScaler();
    return new Hero(
      tag: 'hero',
      child: Container(
        margin: EdgeInsets.only(left: 10.0, bottom: 20.0),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'DesForm',
              style: TextStyle(
                color: Color(0xffffffff),
                fontSize: scaler.getTextSize(10.6),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w900,
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 2.0,
                ),
                Text(
                  'Live to Create',
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: scaler.getTextSize(7.0),
                    fontFamily: 'Montserrat',
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(
          fontFamily: 'Montserrat'
        ),
        decoration: new InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(
              fontFamily: 'Montserrat'
            ),
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        //validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        validator: (value) {
          if(value.isEmpty){
            h=16.5;
            return 'Email can\'t be empty';
          }
          else{
            return null;
          }
        },
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      margin: EdgeInsets.only(bottom: 10.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(
          fontFamily: 'Montserrat'
        ),
        decoration: new InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              fontFamily: 'Montserrat'
            ),
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    ScreenScaler scaler = ScreenScaler();
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Align(
        child: SizedBox(
          width: scaler.getWidth(22.0),
          child: new FlatButton(
              child: new Text(
                _isLoginForm ? 'Create an account' : 'Have an account?  Sign in',
                style: new TextStyle(
                  fontSize: scaler.getTextSize(7.0),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat'
                )
              ),
              onPressed: toggleFormMode
          ),
        ),
      ),
    );
  }

  Widget showPrimaryButton() {
    ScreenScaler scaler = ScreenScaler();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: Align(
        child: SizedBox(
          width: scaler.getWidth(18.0),
          child: new RaisedButton(
            elevation: 4.0,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            color: Theme.of(context).primaryColor,
            child: new Text(
              _isLoginForm ? 'Login' : 'Create Account',
              style: new TextStyle(
                fontSize: scaler.getTextSize(8.0),
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat'
              ),
            ),
            onPressed: validateAndSubmit,
          ),
        ),
      ),
    );
  }
}