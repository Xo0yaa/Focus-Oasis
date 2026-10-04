import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'main_navigation_screen.dart'; // Adjust path if needed to point to your main layout container

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const LoginScreen({super.key, required this.prefs});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() {
    setState(() => _isLoading = true);
    
    // Simulate lightweight offline check/local login
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      
      // Navigate to main application screen and replace route so back button doesn't loop back to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(prefs: widget.prefs),
        ),
      );
    });
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo Integration
                const AppLogo(size: 64),
                const SizedBox(height: AppSpacing.md),
                
                Text('Focus Oasis', style: OasisTextTheme.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Cultivate your focus, grow your garden',
                  style: OasisTextTheme.labelSmall,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.lg * 2),

                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email or Username',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.md),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Sign In'),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Skip / Guest mode option for offline local-first convenience
                TextButton(
                  onPressed: _handleLogin,
                  child: const Text(
                    'Continue Offline',
                    style: TextStyle(color: AppTheme.accentWater),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}