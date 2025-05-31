import 'package:flutter/material.dart';
import 'package:responsi/pages/phone_page.dart';
import '../models/phone_model.dart';
import '../services/phone_service.dart';

class EditPhonePage extends StatefulWidget {
  final Data data;

  const EditPhonePage({super.key, required this.data});

  @override
  State<EditPhonePage> createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late final TextEditingController _modelController;
  late final TextEditingController _brandController;
  late final TextEditingController _ramController;
  late final TextEditingController _priceController;
  late final TextEditingController _storageController;

  @override
  void initState() {
    super.initState();
    final d = widget.data;
    _modelController = TextEditingController(text: d.model ?? '');
    _brandController = TextEditingController(text: d.brand ?? '');
    _ramController = TextEditingController(text: d.ram?.toString() ?? '');
    _priceController = TextEditingController(text: d.price?.toString() ?? '');
    _storageController = TextEditingController(
      text: d.storage?.toString() ?? '',
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Tidak boleh kosong';
    return null;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final ram = int.tryParse(_ramController.text.trim());
      final price = double.tryParse(_priceController.text.trim());
      final storage = int.tryParse(_storageController.text.trim());

      if (ram == null || price == null || storage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text("RAM, Price, dan Storage harus berupa angka"),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF6C8EAD),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final updated = Data(
        id: widget.data.id,
        model: _modelController.text.trim(),
        brand: _brandController.text.trim(),
        ram: ram,
        price: price,
        storage: storage,
      );

      try {
        print("Mengirim data update: ${updated.toJson()}");
        final response = await PhoneService.updatePhone(updated);

        if (response.status == "Success") {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text("Berhasil memperbarui smartphone"),
                ],
              ),
              backgroundColor: const Color(0xFF4285F4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PhonePage()),
          );
        } else {
          throw Exception(response.message ?? "Gagal memperbarui smartphone");
        }
      } catch (e) {
        print("Error saat update: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text("Gagal: $e")),
              ],
            ),
            backgroundColor: const Color(0xFF6C8EAD),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF1976D2),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon:
            icon != null
                ? Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF1976D2)),
                )
                : null,
        filled: true,
        fillColor: const Color(0xFFF5F8FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF6C8EAD), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF6C8EAD), width: 2),
        ),
        hintStyle: TextStyle(color: const Color(0xFF1976D2).withOpacity(0.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          "Edit Smartphone",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.smartphone,
                          size: 40,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Edit Data Smartphone',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Perbarui informasi smartphone ${widget.data.brand} ${widget.data.model}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF1976D2).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withOpacity(0.15),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Smartphone',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildTextField(
                          controller: _modelController,
                          label: "Model Smartphone",
                          validator: _required,
                          icon: Icons.phone_android,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _brandController,
                          label: "Brand/Merek",
                          validator: _required,
                          icon: Icons.business,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _priceController,
                          label: "Harga (Rp)",
                          validator: _required,
                          keyboardType: TextInputType.number,
                          icon: Icons.attach_money,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _ramController,
                          label: "RAM (GB)",
                          validator: _required,
                          keyboardType: TextInputType.number,
                          icon: Icons.memory,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _storageController,
                          label: "Storage (GB)",
                          validator: _required,
                          keyboardType: TextInputType.number,
                          icon: Icons.storage,
                        ),
                        const SizedBox(height: 32),

                        // Save button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2196F3).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                    : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.save, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          "SIMPAN PERUBAHAN",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
