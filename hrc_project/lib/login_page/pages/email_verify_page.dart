// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/dialog_page/show_dialog.dart';
import 'package:hrc_project/nav_bar/navigation_bar.dart';
import '../auth/auth_page.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({Key? key}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  String user_name = '';
  String email = '';
  String user_image = '';

  //  Get user data from cloud Firestore
  Future _getUserData() async {
    final user = await FirebaseAuth.instance.currentUser;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userData.get().then(
          (value) => {
            user_name = value['user_name'],
            email = value['email'],
            user_image = value['user_image'],
          },
        );
  }

  //  Delete user data and account from firebase
  Future deleteUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final deleteUserProfileImage = await FirebaseStorage.instance
        .ref()
        .child('profile_image')
        .child(user.uid);

    //  delete user profile image
    await deleteUserProfileImage.delete();

    //  delete user data
    await userData.delete();

    //  delete user account
    await user.delete();

    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              //  Page back arrow
              Padding(
                padding: EdgeInsets.only(left: 20, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AuthPage();
                            },
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 15),
                  //  HRC Logo
                  Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('image/Logo1.png'),
                          fit: BoxFit.fitWidth),
                    ),
                  ),

                  SizedBox(height: 50),

                  Text(
                    'Request to send authentication email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 45),

                  Text(
                    'The account currently logged in:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10),

                  //  user profile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Color.fromARGB(255, 46, 36, 80),
                      ),
                      child: Stack(
                        children: [
                          //  profile setting button (modify)
                          Padding(
                            padding: const EdgeInsets.only(top: 15, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return alternativeDialog(
                                            context,
                                            150,
                                            30,
                                            '회원 탈퇴하기',
                                            15,
                                            '계정을 삭제하시겠습니까?',
                                            15,
                                            Navigator.of(context).pop,
                                            confirmDialog(
                                                context,
                                                email,
                                                Navigator.of(context).pop,
                                                deleteUserData,
                                                () {},
                                                () {}),
                                            () {},
                                            () {});
                                      },
                                    );
                                  },
                                  child: RadiantGradientMask2(
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FutureBuilder(
                            future: _getUserData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 21, bottom: 21),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color.fromRGBO(
                                                  248, 103, 248, 0.95),
                                              Color.fromRGBO(61, 90, 230, 1)
                                            ],
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 45,
                                          backgroundColor: Colors.grey[200],
                                          foregroundImage:
                                              NetworkImage(user_image),
                                          child: Icon(
                                            Icons.account_circle,
                                            size: 75,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '${user_name}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${email}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 21, bottom: 21),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  //  Send email button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        // loading circle
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(child: CircularProgressIndicator());
                          },
                        );
                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                        //  pop the loading circle
                        Navigator.of(context).pop();
                        //  email send alert
                        showDialog(
                            context: context,
                            builder: (context) {
                              return flexibleDialog(
                                  context,
                                  150,
                                  30,
                                  '알림',
                                  15,
                                  '이메일이 발송되었습니다.\n메일함에 보이지 않는다면 스팸 함을 확인하여 주십시오.',
                                  14,
                                  () {},
                                  () {},
                                  () {},
                                  () {});
                            });
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              colors: [
                                Color.fromRGBO(129, 97, 208, 0.45),
                                Color.fromARGB(255, 61, 90, 230)
                              ]),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.outgoing_mail,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(width: 15),
                            Text(
                              'Send authentication mail',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 80),

                  //  Sign in button
                  GestureDetector(
                    onTap: () async {
                      // loading circle
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                      await FirebaseAuth.instance.currentUser!.reload();
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        //  pop the loading circle
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NavigationBarPage();
                            },
                          ),
                        );
                      } else {
                        //  pop the loading circle
                        Navigator.of(context).pop();
                        //  email verity alert
                        showDialog(
                            context: context,
                            builder: (context) {
                              return flexibleDialog(
                                  context,
                                  150,
                                  30,
                                  '알림',
                                  15,
                                  '이메일 인증을 완료하여 주십시오.',
                                  15,
                                  () {},
                                  () {},
                                  () {},
                                  () {});
                            });
                      }
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width * 0.6),
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Color.fromRGBO(129, 97, 208, 0.75),
                              Color.fromRGBO(186, 104, 186, 1)
                            ]),
                      ),
                      child: Center(
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

//  Icon gradient funcfion
class RadiantGradientMask2 extends StatelessWidget {
  RadiantGradientMask2({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 125, 125, 1),
          Color.fromRGBO(255, 125, 125, 0.27),
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
