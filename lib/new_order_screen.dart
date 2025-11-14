import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'app_constant.dart';
import 'custom_text_field.dart';
import 'order_model.dart';
import 'primary_button.dart';
import 'supabase_service.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _imageFile;

  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerCityController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerCityController.dispose();
    _customerAddressController.dispose();
    _productController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _imageFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
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
  
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _submitOrder(String status) async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields.');
      return;
    }

    if (SupabaseService.currentUserId == null) {
      _showErrorSnackBar('You must be logged in to create an order.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final order = Order(
        affiliateId: SupabaseService.currentUserId!,
        customerName: _customerNameController.text,
        customerPhone: _customerPhoneController.text,
        customerCity: _customerCityController.text,
        customerAddress: _customerAddressController.text,
        productName: _productController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        notes: _notesController.text,
        status: status,
      );

      await SupabaseService.createOrder(order: order, imageFile: _imageFile);
      
      _showSuccessSnackBar(status == 'draft' ? 'Order saved as draft!' : 'Order submitted successfully!');
      if(mounted) Navigator.pop(context);

    } catch (e) {
      _showErrorSnackBar('Failed to create order: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Order', style: GoogleFonts.cairo()),
        backgroundColor: AppConstant.SURFACE_COLOR,
      ),
      body: _isLoading ? _buildLoadingView() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
        children: [
          _buildSectionHeader('Customer Details'),
          CustomTextField(controller: _customerNameController, labelText: 'Customer Name', prefixIcon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          CustomTextField(controller: _customerPhoneController, labelText: 'Phone Number', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          CustomTextField(controller: _customerCityController, labelText: 'City', prefixIcon: Icons.location_city_outlined, validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          CustomTextField(controller: _customerAddressController, labelText: 'Address', prefixIcon: Icons.location_on_outlined, validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: AppConstant.PADDING_LARGE),
          _buildSectionHeader('Product Details'),
          CustomTextField(controller: _productController, labelText: 'Product Name', prefixIcon: Icons.shopping_bag_outlined, validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          CustomTextField(controller: _priceController, labelText: 'Price', prefixIcon: Icons.attach_money_outlined, keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          _buildImagePicker(),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          CustomTextField(controller: _notesController, labelText: 'Notes (Optional)', prefixIcon: Icons.notes_outlined),
          const SizedBox(height: AppConstant.PADDING_XL),
          PrimaryButton(text: 'Submit Order', onPressed: () => _submitOrder('pending_review')),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          OutlinedButton(
            onPressed: () => _submitOrder('draft'),
            child: Text('Save as Draft', style: GoogleFonts.poppins(color: AppConstant.PRIMARY_COLOR)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppConstant.PRIMARY_COLOR),
              padding: const EdgeInsets.symmetric(vertical: AppConstant.PADDING_MEDIUM),
               shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_LARGE),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstant.PADDING_MEDIUM),
      child: Text(title, style: GoogleFonts.cairo(fontSize: AppConstant.FONT_TITLE, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppConstant.SURFACE_COLOR,
          borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_LARGE),
          border: Border.all(color: AppConstant.TEXT_SECONDARY, width: 1),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_LARGE),
                child: Image.file(_imageFile!, fit: BoxFit.cover),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: AppConstant.TEXT_SECONDARY, size: 40),
                  SizedBox(height: AppConstant.PADDING_SMALL),
                  Text('Upload Image (Optional)', style: TextStyle(color: AppConstant.TEXT_SECONDARY)),
                ],
              ),
      ),
    );
  }

   Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: AppConstant.SURFACE_COLOR,
      highlightColor: AppConstant.SURFACE_COLOR.withOpacity(0.5),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: List.generate(8, (index) => Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_LARGE),
          ),
        )),
      ),
    );
  }
}