import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPhoneController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  String _registerRole = 'affiliate';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // الهيدر مع اللوغو
              _buildHeader(),
              SizedBox(height: 30),
              // نموذج المصادقة
              _buildAuthContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // اللوغو واسم التطبيق
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة اللوغو
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF00ADB5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.3)),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_cart_rounded,
                        size: 30,
                        color: Color(0xFF00ADB5),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 15),
              // اسم ووصف التطبيق
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BMG Corp',
                    style: TextStyle(
                      color: Color(0xFF00ADB5),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    'نظام إدارة التسويق',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          // رسالة الترحيب
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Color(0xFF00ADB5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.2)),
            ),
            child: Text(
              'مرحباً بك في نظام إدارة التسويق بالعمولة والتوصيل',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontFamily: 'Cairo',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthContainer() {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: _isLogin ? _buildLoginForm() : _buildRegisterForm(),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          Text(
            'تسجيل الدخول',
            style: TextStyle(
              color: Color(0xFF00ADB5),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 25),
          _buildTextField(
            controller: _loginEmailController,
            label: 'البريد الإلكتروني',
            isEmail: true,
          ),
          SizedBox(height: 20),
          _buildTextField(
            controller: _loginPasswordController,
            label: 'كلمة المرور',
            isPassword: true,
          ),
          SizedBox(height: 25),
          _buildButton(
            text: 'تسجيل الدخول',
            onPressed: _handleLogin,
            color: Color(0xFF00ADB5),
          ),
          SizedBox(height: 15),
          _buildButton(
            text: 'إنشاء حساب جديد',
            onPressed: () => setState(() => _isLogin = false),
            color: Color(0xFF6C7B7F),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              color: Color(0xFF00ADB5),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 25),
          _buildTextField(
            controller: _registerNameController,
            label: 'الاسم الكامل',
          ),
          SizedBox(height: 20),
          _buildTextField(
            controller: _registerEmailController,
            label: 'البريد الإلكتروني',
            isEmail: true,
          ),
          SizedBox(height: 20),
          _buildTextField(
            controller: _registerPhoneController,
            label: 'رقم الهاتف',
            isPhone: true,
          ),
          SizedBox(height: 20),
          _buildDropdown(),
          SizedBox(height: 20),
          _buildTextField(
            controller: _registerPasswordController,
            label: 'كلمة المرور',
            isPassword: true,
          ),
          SizedBox(height: 25),
          _buildButton(
            text: 'إنشاء الحساب',
            onPressed: _handleRegister,
            color: Color(0xFF00ADB5),
          ),
          SizedBox(height: 15),
          _buildButton(
            text: 'العودة لتسجيل الدخول',
            onPressed: () => setState(() => _isLogin = true),
            color: Color(0xFF6C7B7F),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhone
          ? TextInputType.phone
          : TextInputType.text,
      style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        filled: true,
        fillColor: Color(0xFF16213E).withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF00ADB5).withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF00ADB5).withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF00ADB5)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _registerRole,
      decoration: InputDecoration(
        labelText: 'الدور',
        labelStyle: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        filled: true,
        fillColor: Color(0xFF16213E).withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dropdownColor: Color(0xFF1A1A2E),
      style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
      items: [
        DropdownMenuItem(value: 'affiliate', child: Text('مسوّق')),
        DropdownMenuItem(value: 'call_center', child: Text('مؤكد الطلبات')),
        DropdownMenuItem(value: 'driver', child: Text('سائق')),
        DropdownMenuItem(value: 'assistant_admin', child: Text('مساعد إداري')),
        DropdownMenuItem(value: 'admin', child: Text('مدير')),
      ],
      onChanged: (value) {
        setState(() {
          _registerRole = value!;
        });
      },
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      final users = Provider.of<AppState>(context, listen: false).users;
      final user = users.firstWhere(
        (u) => u.email == _loginEmailController.text && 
               u.password == _loginPasswordController.text,
        orElse: () => User(
          id: '',
          name: '',
          email: '',
          role: '',
          phone: '',
        ),
      );

      if (user.id.isNotEmpty) {
        Provider.of<AppState>(context, listen: false).setUser(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        _showErrorDialog('خطأ في تسجيل الدخول', 'البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }
    }
  }

  void _handleRegister() {
    if (_registerFormKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);
      final users = appState.users;
      
      final existingUser = users.firstWhere(
        (u) => u.email == _registerEmailController.text,
        orElse: () => User(
          id: '',
          name: '',
          email: '',
          role: '',
          phone: '',
        ),
      );

      if (existingUser.id.isNotEmpty) {
        _showErrorDialog('خطأ في التسجيل', 'البريد الإلكتروني مستخدم بالفعل');
        return;
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _registerNameController.text,
        email: _registerEmailController.text,
        role: _registerRole,
        phone: _registerPhoneController.text,
        password: _registerPasswordController.text,
      );

      appState.addUser(newUser);
      appState.setUser(newUser);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1A1A2E),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'حسناً',
              style: TextStyle(
                color: Color(0xFF00ADB5),
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}