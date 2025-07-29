import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:time4play/screens/sign_up_and_steps/create_profile.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUpAction() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => CreateProfile(
            emailController: _emailController,
            passwordController: _passwordController,
          ),
        ),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF121212), Color(0xFF0D47A1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Sign Up",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),
                              _buildEmailField(isDarkMode),
                              const SizedBox(height: 16),
                              _buildPasswordField(isDarkMode),
                              const SizedBox(height: 16),
                              _buildConfirmPasswordField(isDarkMode),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _signUpAction,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                isIos ? Icons.arrow_back_ios_new : Icons.arrow_back,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(bool isDarkMode) {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter your email";
        if (!EmailValidator.validate(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
      decoration: _inputDecoration(
          hint: "Email",
          prefixIcon: Icons.email_outlined,
          isDarkMode: isDarkMode),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField(bool isDarkMode) {
    return TextFormField(
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter your password";
        if (value.length < 6) return "Password must be at least 6 characters";
        return null;
      },
      decoration: _inputDecoration(
        hint: "Password",
        isDarkMode: isDarkMode,
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: isDarkMode ? null : Theme.of(context).colorScheme.secondary,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      obscureText: !_isPasswordVisible,
    );
  }

  Widget _buildConfirmPasswordField(bool isDarkMode) {
    return TextFormField(
      controller: _confirmPasswordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please confirm your password";
        }
        if (value != _passwordController.text) return "Passwords do not match";
        return null;
      },
      decoration: _inputDecoration(
        hint: "Confirm Password",
        isDarkMode: isDarkMode,
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: isDarkMode ? null : Theme.of(context).colorScheme.secondary,
          ),
          onPressed: _toggleConfirmPasswordVisibility,
        ),
      ),
      obscureText: !_isConfirmPasswordVisible,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
    required bool isDarkMode,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon:
          Icon(prefixIcon, color: Theme.of(context).colorScheme.secondary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDarkMode ? const Color(0xFF1E1E1E) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
