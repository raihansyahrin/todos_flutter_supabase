import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todos_supabase/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _redirect();
    super.initState();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    final session = supabase.auth.currentSession;
    print('current session $session');

    print('user id from splash ${session?.user.id}');

    if (!mounted) return;
    if (session == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
    // if (session != null) {
    //   Navigator.of(context).pushReplacementNamed('/todos');
    // } else {
    //   Navigator.of(context).pushReplacementNamed('/login');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
