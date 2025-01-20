import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todos_supabase/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final StreamSubscription<AuthState> authSubscription;
  @override
  void initState() {
    super.initState();
    authSubscription = supabase.auth.onAuthStateChange.listen(
      (event) {
        final session = event.session;
        print('session $session');
        if (session != null) {
          Navigator.of(context).pushReplacementNamed('/todos');
        }
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              label: Text('Email'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              label: Text('Passowrd'),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  // await supabase.auth.signInWithOtp(
                  //   email: email,
                  //   emailRedirectTo:
                  //       'io.supabase.flutterquickstart://login-callback/',
                  // );
                  await supabase.auth.signInWithPassword(
                    email: email,
                    password: password,
                  );

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Welcome!'),
                    ),
                  );
                } on AuthException catch (e) {
                  print(e);
                  print(e.statusCode);
                  if (e.statusCode == "400") {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          // e.statusCode!,
                          e.message,
                        ),
                      ),
                    );
                  } else if (e.statusCode == "429") {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          // e.statusCode!,
                          e.message,
                        ),
                      ),
                    );
                  } else if (e.statusCode == "403") {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          // e.statusCode!,
                          e.message,
                        ),
                      ),
                    );
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          // e.statusCode!,
                          e.message,
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  print(e.toString());
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                }
              },
              child: Text('Login'))
          //  TextFormField(
          //   controller: emailController,
          //   decoration: InputDecoration(
          //     label: Text('Passowrd'),
          //   ),
          // )
        ],
      ),
      bottomNavigationBar: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/register');
        },
        child: Text('Register'),
      ),
    );
  }
}
