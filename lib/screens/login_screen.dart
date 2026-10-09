import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/account_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final bool hasSupabaseConfig;

  const LoginScreen(
      {super.key, required this.prefs, required this.hasSupabaseConfig});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isCreatingAccount = false;

  @override
  void initState() {
    super.initState();
    if (widget.hasSupabaseConfig &&
        Supabase.instance.client.auth.currentSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openApp());
    }
  }

  Future<void> _authenticate() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || !email.contains('@') || password.length < 6) {
      _showMessage(
          'Enter a valid email and a password with at least 6 characters.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final account = AccountService(Supabase.instance.client);
      if (_isCreatingAccount) {
        final result = await account.signUp(email, password);
        if (!mounted) return;
        if (result.session == null) {
          _showMessage(
              'Check your email to confirm your account, then sign in.');
          setState(() => _isCreatingAccount = false);
          return;
        }
      } else {
        await account.signIn(email, password);
      }
      _openApp();
    } on AuthException catch (error) {
      _showMessage(error.message);
    } on PostgrestException catch (error) {
      _showMessage(
          'Signed in, but account data could not be loaded: ${error.message}');
    } catch (_) {
      _showMessage(
          'Could not connect. Check your Supabase setup and internet connection.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _continueOffline() => _openApp();

  void _openApp() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigationScreen(
          prefs: widget.prefs,
          cloudClient: widget.hasSupabaseConfig &&
                  Supabase.instance.client.auth.currentSession != null
              ? Supabase.instance.client
              : null,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(size: 64),
                  const SizedBox(height: AppSpacing.md),
                  Text('Focus Oasis', style: OasisTextTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Cultivate your focus, grow your garden',
                      style: OasisTextTheme.labelSmall,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.lg * 2),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading || !widget.hasSupabaseConfig
                          ? null
                          : _authenticate,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text(_isCreatingAccount
                              ? 'Create Account'
                              : 'Sign In'),
                    ),
                  ),
                  if (widget.hasSupabaseConfig)
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => setState(
                              () => _isCreatingAccount = !_isCreatingAccount),
                      child: Text(_isCreatingAccount
                          ? 'Already registered? Sign in'
                          : 'New here? Create an account'),
                    )
                  else ...[
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                        'Add Supabase settings to enable email accounts.',
                        textAlign: TextAlign.center),
                  ],
                  TextButton(
                    onPressed: _isLoading ? null : _continueOffline,
                    child: const Text('Continue Offline',
                        style: TextStyle(color: AppTheme.accentWater)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
