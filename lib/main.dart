import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SunnyApp());
}

class SunnyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  User? user;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; // user cancelled
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);

    setState(() {
      user = userCred.user;
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: signInWithGoogle,
            child: Text("Login with Google"),
          ),
        ),
      );
    } else {
      bool isAdmin = user!.email == "sunnyjumani10789@gmail.com";
      return Scaffold(
        appBar: AppBar(
          title: Text(isAdmin ? "Admin Panel" : "User Panel"),
          actions: [
            IconButton(onPressed: signOut, icon: Icon(Icons.logout))
          ],
        ),
        body: Center(
          child: Text(
            isAdmin
                ? "Welcome Admin Sunny!"
                : "Welcome ${user!.displayName}",
            style: TextStyle(fontSize:
