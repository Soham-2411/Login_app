import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final String media;
  const ProfilePage({Key key, this.user, this.media}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

bool _isLoggedOut = false;

class _ProfilePageState extends State<ProfilePage> {
  void initState() {
    super.initState();
    _isLoggedOut = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [HexColor('#5500d7'), HexColor('#6f0095')])),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(width, height),
                  painter: CurvePainter(),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(widget.user.photoURL),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.user.displayName,
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.user.email,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 200),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 8,
                              shadowColor: Colors.purple,
                              primary: Colors.transparent,
                              padding: EdgeInsets.all(0)),
                          onPressed: () async {
                            if (widget.media == 'Google') {
                              await googleLogout();
                            } else {
                              await facebookLogout();
                            }
                            setState(() {
                              _isLoggedOut = true;
                            });
                            await Future.delayed(Duration(milliseconds: 500));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                            width: 120,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      HexColor('#5500d7'),
                                      HexColor('#6f0095')
                                    ])),
                            child: Center(child: Text("Logout")),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          (_isLoggedOut)
              ? Container(
                  width: width,
                  height: height,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container(),
        ],
      ),
    );
  }
}

class AnonymousLogin extends StatefulWidget {
  final String name;
  final String email;

  const AnonymousLogin({Key key, this.name = ' ', this.email = ' '})
      : super(key: key);
  @override
  AnonymousLoginState createState() => AnonymousLoginState();
}

class AnonymousLoginState extends State<AnonymousLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/Profile.png'))),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80),
              SizedBox(height: 10),
              Text(
                widget.name,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                widget.email,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(height: 250),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      shadowColor: Colors.purple,
                      primary: Colors.transparent,
                      padding: EdgeInsets.all(0)),
                  onPressed: () async {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              HexColor('#5500d7'),
                              HexColor('#6f0095')
                            ])),
                    child: Center(child: Text("Logout")),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.4);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.55);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
