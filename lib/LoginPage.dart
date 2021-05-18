import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_app/Profile.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

String name;
String email = '';

FacebookLogin fbLogin = new FacebookLogin();
bool _isLoggedIn = false;
User user;
GoogleSignIn _googleSignIn = new GoogleSignIn();

class _LoginState extends State<Login> {
  void initState() {
    super.initState();
    name = '';
    email = '';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/Background.png'),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 30),
                          Text("Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: height / 3 - 140),
                          Padding(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Hello!",
                                    style: TextStyle(
                                        color: HexColor('#5500d7'),
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800))),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 60),
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: HexColor('#5500d7'),
                                  ),
                                  labelText: "Name"),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 60),
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: HexColor('#5500d7'),
                                  ),
                                  labelText: "Email (Optional)"),
                            ),
                          ),
                          SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.only(right: 55.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 8,
                                      shadowColor: Colors.purple,
                                      primary: Colors.transparent,
                                      padding: EdgeInsets.all(0)),
                                  onPressed: () {
                                    if (name == '') {
                                      showAlertDialog(context);
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AnonymousLogin(
                                                    name: name,
                                                    email: (email == '')
                                                        ? ' '
                                                        : email,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                    width: 130,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              HexColor('#5500d7'),
                                              HexColor('#6f0095')
                                            ])),
                                    child: Center(
                                        child: Text("Login (Anonymously)")),
                                  )),
                            ),
                          ),
                          SizedBox(height: height / 3 - 80),
                          Text(
                            "OR",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "Login with social media",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await _handleGooglelogin();
                                },
                                iconSize: 50,
                                icon: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/Google.png'),
                                          fit: BoxFit.contain)),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  _handleFacebookLogin();
                                },
                                iconSize: 40,
                                icon: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/Facebook.png'),
                                          fit: BoxFit.contain)),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
        (_isLoggedIn)
            ? Container(
                width: width,
                height: height,
                color: Colors.black.withOpacity(0.5),
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(),
      ],
    );
  }

  Future _handleGooglelogin() async {
    setState(() {
      _isLoggedIn = true;
    });
    final _user = await _googleSignIn.signIn();
    if (_user != null) {
      final googleAuth = await _user.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      var a = await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _isLoggedIn = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    user: a.user,
                    media: "Google",
                  )));
    }
  }

  Future _handleFacebookLogin() async {
    setState(() {
      _isLoggedIn = true;
    });
    FacebookLoginResult result = await fbLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        await _loginWithFacebook(result);
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("Error");
        break;
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _token = _result.accessToken;
    AuthCredential _credential = FacebookAuthProvider.credential(_token.token);
    var a = await FirebaseAuth.instance.signInWithCredential(_credential);
    setState(() {
      _isLoggedIn = false;
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                  user: a.user,
                  media: "Facebook",
                )));
  }
}

Future<void> googleLogout() async {
  final user = await FirebaseAuth.instance.currentUser;
  user.delete();
  await FirebaseAuth.instance
      .signOut()
      .then((value) => {_googleSignIn.disconnect()});
}

Future<void> facebookLogout() async {
  final user = await FirebaseAuth.instance.currentUser;
  user.delete();
  await FirebaseAuth.instance.signOut().then((value) => {fbLogin.logOut()});
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "OK",
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    backgroundColor: HexColor('#5500d7'),
    title: Text("Empty Field", style: TextStyle(color: Colors.white)),
    content:
        Text("Please enter your name", style: TextStyle(color: Colors.white)),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
