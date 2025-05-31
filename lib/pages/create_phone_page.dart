import 'package:flutter/material.dart';
import '../models/phone_model.dart';
import '../services/phone_service.dart';

class CreatePhonePage extends StatefulWidget {
  final Data? data;
  const CreatePhonePage({super.key, this.data});

  @override
  State<CreatePhonePage> createState() => _CreatePhonePageState();
}

class _CreatePhonePageState extends State<CreatePhonePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _ramController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _storageController = TextEditingController();

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Tidak boleh kosong';
    return null;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newPhone = Data(
        model: _modelController.text.trim(),
        brand: _brandController.text.trim(),
        ram: int.tryParse(_ramController.text.trim()),
        price: double.tryParse(_priceController.text.trim()),
        storage: int.tryParse(_storageController.text.trim()),
      );

      try {
        final response = await PhoneService.createPhone(newPhone);

        if (response.status == "Success") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Berhasil menambah smartphone"),
              backgroundColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          if (!mounted) return;
          Navigator.pop(context, true);
        } else {
          throw Exception(response.message ?? "Gagal menambah smartphone");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal: $e"),
            backgroundColor: Colors.red.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      appBar: AppBar(
        title: const Text(
          "Add New Phone",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2196F3), // Blue app bar
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Header section with icon
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.smartphone,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Add Data Smartphone",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Masukkan informasi smartphone Anda",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(
                    labelText: "Model Smartphone",
                    labelStyle: const TextStyle(color: Color(0xFF2196F3)),
                    prefixIcon: const Icon(
                      Icons.smartphone,
                      color: Color(0xFF2196F3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F9FF),
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: "Brand/Merek",
                    labelStyle: const TextStyle(color: Color(0xFF2196F3)),
                    prefixIcon: const Icon(
                      Icons.business,
                      color: Color(0xFF2196F3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F9FF),
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: "Harga (Rp)",
                    labelStyle: const TextStyle(color: Color(0xFF2196F3)),
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Color(0xFF2196F3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F9FF),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ramController,
                  decoration: InputDecoration(
                    labelText: "RAM (GB)",
                    labelStyle: const TextStyle(color: Color(0xFF2196F3)),
                    prefixIcon: const Icon(
                      Icons.memory,
                      color: Color(0xFF2196F3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F9FF),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _required,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _storageController,
                  decoration: InputDecoration(
                    labelText: "Storage (GB)",
                    labelStyle: const TextStyle(color: Color(0xFF2196F3)),
                    prefixIcon: const Icon(
                      Icons.storage,
                      color: Color(0xFF2196F3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F9FF),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _required,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              "Tambah Smartphone",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
