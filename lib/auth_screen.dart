import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_constant.dart';
import 'custom_text_field.dart';
import 'primary_button.dart';
import 'supabase_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Login controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Signup controllers
  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPhoneController = TextEditingController();
  final _signupCityController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignup = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPhoneController.dispose();
    _signupCityController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstant.ERROR_COLOR,
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKeyLogin.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await SupabaseService.signIn(
        email: _loginEmailController.text.trim(),
        password: _loginPasswordController.text.trim(),
      );
      // Navigation is handled by the StreamBuilder in HomePage
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred.');
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKeySignup.currentState!.validate()) return;
    if (_signupPasswordController.text != _signupConfirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await SupabaseService.signUp(
        email: _signupEmailController.text.trim(),
        password: _signupPasswordController.text.trim(),
        metadata: {
          'name': _signupNameController.text.trim(),
          'phone': _signupPhoneController.text.trim(),
          'city': _signupCityController.text.trim(),
          'role': 'affiliate' // Default role for signup
        },
      );
      // Navigation is handled by the StreamBuilder in HomePage
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred.');
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstant.PADDING_LARGE),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'BMG Connect',
                style: GoogleFonts.cairo(
                  fontSize: AppConstant.FONT_DISPLAY,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.PRIMARY_COLOR,
                ),
              ),
              const SizedBox(height: 40),
              TabBar(
                controller: _tabController,
                indicatorColor: AppConstant.PRIMARY_COLOR,
                labelColor: AppConstant.TEXT_PRIMARY,
                unselectedLabelColor: AppConstant.TEXT_SECONDARY,
                tabs: [
                  Tab(text: 'Login'.toUpperCase()),
                  Tab(text: 'Sign Up'.toUpperCase()),
                ],
              ),
              const SizedBox(height: AppConstant.PADDING_LARGE),
              SizedBox(
                height: 500,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm(),
                    _buildSignUpForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKeyLogin,
      child: Column(
        children: [
          CustomTextField(
            controller: _loginEmailController,
            labelText: 'Email',
            prefixIcon: Icons.email_outlined,
            validator: (val) => val!.isEmpty ? 'Email cannot be empty' : null,
          ),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          CustomTextField(
            controller: _loginPasswordController,
            labelText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            validator: (val) => val!.length < 6 ? 'Password must be 6+ chars' : null,
          ),
          const SizedBox(height: AppConstant.PADDING_LARGE),
          _isLoading
              ? const CircularProgressIndicator()
              : PrimaryButton(text: 'Login', onPressed: _handleLogin),
          TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(color: AppConstant.PRIMARY_COLOR),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKeySignup,
        child: Column(
          children: [
            CustomTextField(
                controller: _signupNameController,
                labelText: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (val) => val!.isEmpty ? 'Name cannot be empty' : null,
            ),
            const SizedBox(height: AppConstant.PADDING_MEDIUM),
             CustomTextField(
                controller: _signupEmailController,
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                validator: (val) => val!.isEmpty || !val.contains('@') ? 'Enter a valid email' : null,
            ),
             const SizedBox(height: AppConstant.PADDING_MEDIUM),
            CustomTextField(
                controller: _signupPhoneController,
                labelText: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (val) => val!.isEmpty ? 'Phone cannot be empty' : null,
            ),
             const SizedBox(height: AppConstant.PADDING_MEDIUM),
            CustomTextField(
                controller: _signupCityController,
                labelText: 'City',
                prefixIcon: Icons.location_on_outlined,
                validator: (val) => val!.isEmpty ? 'City cannot be empty' : null,
            ),
             const SizedBox(height: AppConstant.PADDING_MEDIUM),
            CustomTextField(
                controller: _signupPasswordController,
                labelText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                 validator: (val) => val!.length < 6 ? 'Password must be 6+ chars' : null,
            ),
             const SizedBox(height: AppConstant.PADDING_MEDIUM),
            CustomTextField(
                controller: _signupConfirmPasswordController,
                labelText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                 validator: (val) => val != _signupPasswordController.text ? 'Passwords do not match' : null,
            ),
            const SizedBox(height: AppConstant.PADDING_LARGE),
            _isLoading
                ? const CircularProgressIndicator()
                : PrimaryButton(text: 'Sign Up', onPressed: _handleSignUp),
          ],
        ),
      ),
    );
  }
}