import 'package:flutter/material.dart';

void main() => runApp(const LoginDemoApp());

class LoginDemoApp extends StatelessWidget {
  const LoginDemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Secure Login Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff3977c3)),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false, _signedIn = false, _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _busy = false;
      _signedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: _signedIn ? _welcome(context) : _loginForm(context),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _welcome(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 32, child: Icon(Icons.check, size: 34)),
          const SizedBox(height: 16),
          Text('Welcome!', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Demo signed in as ${_email.text}'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => setState(() {
              _signedIn = false;
              _password.clear();
            }),
            child: const Text('Sign out'),
          ),
        ],
      );

  Widget _loginForm(BuildContext context) => Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 42),
            const SizedBox(height: 12),
            Text('Welcome back', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            const Text('Sign in to continue', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()),
              validator: (value) => value != null && RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim()) ? null : 'Enter a valid email',
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.key), border: const OutlineInputBorder(), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscure = !_obscure))),
              validator: (value) => value != null && value.length >= 8 ? null : 'Use at least 8 characters',
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _busy ? null : _login,
              child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Sign in'),
            ),
            const SizedBox(height: 14),
            const Text('Demo only: no credentials are sent or saved. A real app should use Firebase Authentication.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      );
}
