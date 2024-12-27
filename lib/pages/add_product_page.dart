import 'package:ecommerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:ecommerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La descripción es obligatoria";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: "URL de la imagen",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La URL de la imagen es obligatoria";
                  }
                  if (!Uri.parse(value).isAbsolute) {
                    return "Debe ser una URL válida";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Precio",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El precio es obligatorio";
                  }
                  if (double.tryParse(value) == null) {
                    return "Debe ser un número válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.green,
                    foregroundColor: AppColor.black,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<EcommerceBloc>().add(
                            CreateNewProductEvent(
                              description: _descriptionController.text,
                              imageUrl: _imageUrlController.text,
                              price: int.parse(_priceController.text),
                              category: "General",
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Agregar producto"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
